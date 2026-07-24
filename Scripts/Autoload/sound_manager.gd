extends  Node

enum MusicTransition {NONE, CROSSFADE, FADE_OUT_IN}

@onready var music : Dictionary[String, AudioStreamPlayer] = {
	"BGM" : %BGMusic
	}

@onready var sfx : Dictionary[String, AudioStreamPlayer] = {
	# UI SFX
	"BtnSFX" : %BtnClick,
	
	# Player SFX
	"Firing" : %FireSFX,

	# Mob SFX
	"Attacking" : %GobAtkSFX

	# Boss SFX


	}


var current_music : AudioStreamPlayer
var music_tween : Tween
const TRANSITION_DURATION : float = 2

func Play_SFX(type: String) -> void:
	if sfx.has(type):
		sfx[type].play()
	

func Play_Music(music_name : String, transition : MusicTransition) -> void:
	var new_music : AudioStreamPlayer = music[music_name]
	
	if current_music == new_music:
		return
	
	if music_tween != null:
		music_tween.kill()
	
	match transition:
		MusicTransition.NONE:
			if current_music != null:
				current_music.stop()
			
			new_music.volume_linear = 1.0
			new_music.play()
		
		MusicTransition.CROSSFADE:
			music_tween = create_tween().set_parallel(true).set_ignore_time_scale()
			
			if current_music != null:
				music_tween.tween_property(current_music, "volume_linear", 0.0, TRANSITION_DURATION)
			
			new_music.volume_linear = 0.0
			new_music.play()
			music_tween.tween_property(new_music, "volume_linear", 1.0, TRANSITION_DURATION)
			
			await music_tween.finished
			if current_music != null:
				current_music.stop()
		
		MusicTransition.FADE_OUT_IN:
			if current_music != null:
				music_tween = create_tween().set_ignore_time_scale()
				music_tween.tween_property(current_music, "volume_linear", 0.0, TRANSITION_DURATION)
				await music_tween.finished
				current_music.stop()
			
			new_music.volume_linear = 0.0
			new_music.play()
			music_tween = create_tween().set_ignore_time_scale()
			music_tween.tween_property(new_music, "volume_linear", 1.0, TRANSITION_DURATION)
	
	current_music = new_music

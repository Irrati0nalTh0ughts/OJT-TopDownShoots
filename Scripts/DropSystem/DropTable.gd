extends Resource

class_name DropTable

@export var entry_list : Array[DataEntry]
@export var nothing_weight : int = 30


func DropRNG():
	var total_weight = nothing_weight
	
	for i in range(entry_list.size()):
		total_weight += entry_list[i].weight
	
	var roll : int = randi_range(1,total_weight)
	
	if roll <= nothing_weight:
		return null
	
	var current_weight = nothing_weight
	
	for i in range(entry_list.size()):
		current_weight += entry_list[i].weight
		
		if roll <= current_weight:
			return entry_list[i].ItemData

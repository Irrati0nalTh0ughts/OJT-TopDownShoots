# OJT Top-Down Shooter (Godot 4.4.1)

A top-down shooter prototype developed during my On-the-Job Training (OJT) to practice game development concepts using Godot 4.4.1.

The goal of this project is not only to build a playable game, but also to explore scalable game architecture by implementing reusable systems instead of hardcoding mechanics.

## Features

- 8-direction player movement and aiming
- Mouse-controlled shooting
- Enemy spawning system
- Wave-based progression
- Collectible drop system
- Weighted loot tables using custom Resource classes
- Temporary Coffee speed buff
- Temporary Gun Mod multi-shot buff
- Collectible despawn timer
- Modular data-driven collectible system
- Resource-based configuration for item effects and drop rates

## Systems Implemented

### Collectible System
- CollectibleData Resource
- DropEntry Resource
- DropTable Resource
- Weighted random drop selection
- Configurable drop tables per enemy

### Buff System
- Temporary movement speed boost
- Temporary weapon spread upgrade
- Timer-based buff duration

### Architecture
- Signal-driven communication
- Resource-driven configuration
- Modular spawning system
- Separation between game data and gameplay logic

## Technologies

- Godot Engine 4.4.1
- GDScript
- Git & GitHub

## Purpose

This repository serves as my OJT learning log and game development practice project. Throughout development I focus on improving software architecture, debugging techniques, and creating reusable systems rather than only implementing gameplay features.

More features will be added as the project progresses.

# OJT Top-Down Shooter (Godot 4.4.1)

A top-down shooter prototype developed during my On-the-Job Training (OJT) using **Godot 4.4.1**.

Rather than focusing on creating a polished game, this project serves as a software engineering exercise in game development. The primary objective is to design reusable, modular, and scalable gameplay systems while practicing clean architecture, event-driven programming, and data-driven design.

---

# Features

## Core Gameplay
- 8-direction player movement
- Mouse-controlled aiming and shooting
- Limited ammunition system
- Wave-based enemy progression
- Enemy spawning system
- Pause menu
- Main menu with persistent settings

## Collectibles & Power-ups
- Ammo Box (restores ammunition)
- Coffee (temporary movement speed boost)
- **Special Coffee** (temporarily slows down time while the player remains unaffected)
- **Special Gun Mod** (temporarily enables a triple-shot weapon)
- **Special Life** (temporarily grants 999 health)

## Loot System
- Enemy item drops
- Weighted random loot tables
- Configurable drop tables per enemy
- Collectible despawn timer

---

# Systems Implemented

## AI & Enemy Systems
- Wave spawning
- Configurable enemy spawning
- Weighted enemy variant spawning

## Collectible System
- CollectibleData Resource
- DropEntry Resource
- DropTable Resource
- Weighted random drop selection
- Resource-driven collectible effects
- Configurable enemy drop tables

## Buff System
- Temporary movement speed boost
- Temporary triple-shot weapon upgrade
- Temporary high-health power-up
- Temporary time-slow effect
- Timer-based buff management

## Weapon System
- Limited ammunition
- Ammo pickups
- Temporary weapon modifiers

## UI System
- Modular Game UI
- Separate Player HUD
- Pause Menu
- Persistent Settings Menu
- Saved user preferences
  - Resolution
  - Window Mode
  - VSync
  - FPS Limit
  - Stored using local configuration files

## Architecture
- Event-driven communication using Signals
- Resource-driven configuration
- Modular spawning system
- Separation between gameplay logic and game data
- Script refactoring for maintainability
- Data-driven gameplay configuration

---

# Planned Features

- Dash attack system
- Additional enemy types
- Additional collectible effects
- More weapon modifiers
- More enemy behaviors
- Improved balancing for ammo economy

The limited ammunition system is designed to encourage resource management. Running out of ammunition leaves the player vulnerable until additional ammo drops are obtained, with future updates introducing alternative offensive options such as dash-based attacks.

---

# Technologies

- Godot Engine 4.4.1
- GDScript
- Git
- GitHub

---

# Learning Objectives

This repository serves as both my OJT learning log and a practical software engineering exercise.

The project's primary focus is on practicing:

- Modular game architecture
- Event-driven programming
- Data-driven design using Resources
- Reusable gameplay systems
- Component-oriented design
- Code refactoring and maintainability
- Debugging and problem solving
- Scalable game development practices

Visual assets, effects, animations, and overall game polish are intentionally secondary. The emphasis is on building maintainable systems that can scale as the project grows.

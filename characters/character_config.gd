class_name CharacterConfig extends Resource


@export var scene: PackedScene

@export var health: float = 100.0
@export var attack_percent: float = 0.0
@export var attack_flat: float = 0.0
@export var defense_percent: float = 0.0
@export var defense_flat: float = 0.0

@export var slot_abilities: Dictionary[AbilitySystem.CommandSlot, Ability]
@export var passive_abilities: Array[Ability]

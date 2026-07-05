class_name CharacterConfig extends Resource


@export var id: StringName
@export var scene: PackedScene
@export var input_script: GDScript
@export var stats: CharacterStats
@export var slot_abilities: Dictionary[AbilitySystem.CommandSlot, Ability]
@export var passive_abilities: Array[Ability]

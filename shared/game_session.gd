extends Node


const WORLD_SCENE := "res://world/world.tscn"


var player_character: StringName
var enemy_character: StringName


func start_battle(player_character: StringName, enemy_character: StringName) -> void:
	self.player_character = player_character
	self.enemy_character = enemy_character
	get_tree().change_scene_to_file(WORLD_SCENE)

func has_lineup() -> bool:
	return not player_character.is_empty() and not enemy_character.is_empty()

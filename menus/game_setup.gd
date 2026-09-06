extends Control


const MAIN_MENU_SCENE := "res://menus/main_menu.tscn"


@export var character_registry: CharacterRegistry

@onready var player_list: ItemList = %PlayerList
@onready var enemy_list: ItemList = %EnemyList


func _ready() -> void:
	for config: CharacterConfig in character_registry.characters:
		var display_name: String = String(config.id).capitalize()
		player_list.add_item(display_name)
		enemy_list.add_item(display_name)
	player_list.select(0)
	enemy_list.select(0)

func _on_start_pressed() -> void:
	GameSession.start_battle(selected_id(player_list), selected_id(enemy_list))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func selected_id(list: ItemList) -> StringName:
	return character_registry.characters[list.get_selected_items()[0]].id

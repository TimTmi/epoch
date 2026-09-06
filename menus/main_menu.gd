extends Control


const GAME_SETUP_SCENE := "res://menus/game_setup.tscn"


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(GAME_SETUP_SCENE)

func _on_quit_pressed() -> void:
	get_tree().quit()

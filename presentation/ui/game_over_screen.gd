class_name GameOverScreen extends Control


const MAIN_MENU_SCENE := "res://menus/main_menu.tscn"


@onready var result_label: Label = %Result
@onready var rematch_button: Button = %Rematch


func open(player_died: bool) -> void:
	result_label.text = "You Lose" if player_died else "You Win"
	show()
	rematch_button.grab_focus()
	get_tree().paused = true

func _on_rematch_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

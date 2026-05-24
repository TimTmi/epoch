extends Control


const CHARACTER_INFO = preload("uid://dul6274pcb0qw")

@onready var team_info = $TeamInfo


func add_character_info(character: Character):
	var character_info = CHARACTER_INFO.instantiate()
	team_info.add_child(character_info)
	character_info.set_up_info(character)

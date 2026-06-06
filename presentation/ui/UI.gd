extends Control


const CHARACTER_FRAME = preload("uid://dul6274pcb0qw")

@onready var team_info = $TeamInfo


func add_character_info(character: Character):
	var character_frame: CharacterFrame = CHARACTER_FRAME.instantiate()
	team_info.add_child(character_frame)
	character_frame.set_up_info(character)

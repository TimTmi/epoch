extends VBoxContainer


const MOVE_COOLDOWN = preload("res://ui_elements/move_cooldown.tscn")

@onready var character_name = $VBoxContainer/Name
@onready var health = $VBoxContainer/Health
@onready var moves = $Moves


func set_up_info(character: Character):
	character_name.text = character.name
	health.custom_minimum_size.x = character.health.value
	health.max_value = character.health.value
	health.value = character.health.value
	character.health.stat_changed.connect(_on_health_changed)
	for i in character.moves.get_children():
		var move_cooldown = MOVE_COOLDOWN.instantiate()
		move_cooldown.move = i
		move_cooldown.texture_progress = i.icon
		moves.add_child(move_cooldown)

func _on_health_changed(_old_value: float, new_value: float):
	health.value = new_value

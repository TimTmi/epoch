extends InputController


func _computer_controller():
	var enemy = get_tree().get_first_node_in_group("player")
	if enemy == null:
		return
	var direction = (enemy.position - character.position).normalized()
	character.move(direction)
	if character.punchable:
		character.use_ability("LMB", enemy.position)

extends InputController


const TRIGGER_AREA = preload("uid://qwyoqy8oqpe")


func ready():
	var lmb_trigger_area = TRIGGER_AREA.instantiate()
	lmb_trigger_area.name = "LMBTriggerArea"
	lmb_trigger_area.set_radius(10)
	character.add_child(lmb_trigger_area)
	lmb_trigger_area.body_entered.connect(_lmb_trigger_area_body_entered)
	
	var rmb_trigger_area = TRIGGER_AREA.instantiate()
	rmb_trigger_area.name = "RMBTriggerArea"
	rmb_trigger_area.set_radius(32)
	character.add_child(rmb_trigger_area)
	rmb_trigger_area.body_entered.connect(_rmb_trigger_area_body_entered)
	
	var e_trigger_area = TRIGGER_AREA.instantiate()
	e_trigger_area.name = "ETriggerArea"
	e_trigger_area.set_radius(32)
	character.add_child(e_trigger_area)
	e_trigger_area.body_entered.connect(_e_trigger_area_body_entered)

func _computer_controller():
	var enemy = get_tree().get_first_node_in_group("player")
	if enemy == null:
		return
	move_to(enemy.position)

func _lmb_trigger_area_body_entered(body):
	pass

func _rmb_trigger_area_body_entered(body):
	pass

func _e_trigger_area_body_entered(body):
	pass

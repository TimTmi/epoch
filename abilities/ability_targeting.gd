class_name AbilityTargeting


var caster_position: Vector2
var target: Node2D = null
var target_direction: Vector2 = Vector2.INF
var target_position: Vector2 = Vector2.INF


func _init(intent: AbilityIntent, caster_position: Vector2) -> void:
	self.caster_position = caster_position
	self.target = intent.target
	self.target_direction = intent.target_direction
	self.target_position = intent.target_position

func get_target_direction() -> Vector2:
	var direction: Vector2 = Vector2.INF
	
	if target_direction != Vector2.INF:
		direction = target_direction
	elif target != null:
		direction = target.global_position - caster_position
	elif target_position != Vector2.INF:
		direction = target_position - caster_position
	
	if direction != Vector2.INF:
		direction = direction.normalized()
	
	return direction

func get_target_angle() -> float:
	return get_target_direction().angle()

class_name AbilityContext


var user: Character
var ability_system: AbilitySystem
var instance: AbilityInstance
var target: Node2D = null
var target_direction: Vector2 = Vector2.INF
var target_position: Vector2 = Vector2.INF


func _init(intent: AbilityIntent, user: Character, ability_system: AbilitySystem, instance: AbilityInstance) -> void:
	self.user = user
	self.ability_system = ability_system
	self.instance = instance
	self.target = intent.target
	self.target_direction = intent.target_direction
	self.target_position = intent.target_position

func get_target_direction() -> Vector2:
	var direction: Vector2 = Vector2.INF
	
	if target_direction != Vector2.INF:
		direction = target_direction
	elif target != null:
		direction = target.position - user.position
	elif target_position != Vector2.INF:
		direction = target_position - user.position
	
	if direction != Vector2.INF:
		direction = direction.normalized()
	
	return direction

func get_target_angle() -> float:
	return get_target_direction().angle()

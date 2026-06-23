class_name AbilityIntent


var target_position: Vector2 = Vector2.INF
var target_direction: Vector2 = Vector2.INF
var target: Node2D = null


static func from_target_position(target_position: Vector2) -> AbilityIntent:
	var intent: AbilityIntent = AbilityIntent.new()
	intent.target_position = target_position
	return intent

static func from_target_direction(target_direction: Vector2) -> AbilityIntent:
	var intent: AbilityIntent = AbilityIntent.new()
	intent.target_direction = target_direction.normalized()
	return intent

static func from_target(target: Node2D) -> AbilityIntent:
	var intent: AbilityIntent = AbilityIntent.new()
	intent.target = target
	return intent

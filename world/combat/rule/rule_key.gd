class_name RuleKey


enum Phase { BEFORE, AFTER }
enum Hook {
	DAMAGE_DEALT,
	DAMAGE_TAKEN,
	HEALING_GIVEN,
	HEALING_RECEIVED,
	HEALTH_CHANGED,
	PUSH_GIVEN,
	PUSH_RECEIVED
}


#var character: Character
#var phase: Phase
#var hook: Hook
var value: StringName


func _init(character: Character, phase: Phase, hook: Hook) -> void:
	value = "%s:%s:%s" % [character.get_instance_id(), phase, hook]

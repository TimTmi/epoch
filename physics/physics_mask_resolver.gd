class_name PhysicsMaskResolver extends Resource


@export var layer_controller: PhysicsLayerController
@export var ruleset: PhysicsInteractionRuleset


func get_layer(team: StringName, sublayer: PhysicsSublayer.Type) -> int:
	if not layer_controller:
		push_warning("Layer controller not assigned")
		return 0
	
	if not layer_controller.has_layer(team):
		push_warning("Unknown team layer: %s" % team)
		return 0
	
	return 1 << layer_controller.get_bit_index(team, sublayer)

func get_mask(source_team: StringName, source_sublayer: PhysicsSublayer.Type, override_ruleset: PhysicsInteractionRuleset = null) -> int:
	if not layer_controller:
		push_warning("Layer controller not assigned")
		return 0
	
	if not ruleset:
		push_warning("Ruleset not assigned")
		return 0
	
	if not layer_controller.has_layer(source_team):
		push_warning("Unknown team layer: %s" % source_team)
		return 0
	
	var active_ruleset: PhysicsInteractionRuleset = override_ruleset if override_ruleset != null else ruleset
	
	var mask: int = 0
	var same_team_mask: int = 0
	var other_team_mask: int = 0
	
	for target_sublayer: int in PhysicsSublayer.Type.values():
		var flags: int = active_ruleset.get_flags(source_sublayer, target_sublayer)
		if flags & PhysicsInteractionFlag.Type.SAME_TEAM:
			same_team_mask |= 1 << target_sublayer
		if flags & PhysicsInteractionFlag.Type.OTHER_TEAM:
			other_team_mask |= 1 << target_sublayer
	
	for team_index: int in layer_controller.layers.values():
		mask |= other_team_mask << team_index
	mask &= ~layer_controller.get_layer_bitmask(source_team)
	mask |= same_team_mask << layer_controller.get_layer_offset(source_team)
	
	return mask

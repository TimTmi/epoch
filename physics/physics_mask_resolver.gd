class_name PhysicsMaskResolver extends Resource


enum CollisionSide { COLLISION_LAYER, COLLISION_MASK }


@export var layer_controller: PhysicsLayerController
@export var ruleset: PhysicsInteractionRuleset


func get_mask(source_team: StringName, source_sublayer: PhysicsSublayer.Type, collision_side: CollisionSide) -> int:
	if not layer_controller.has_layer(source_team):
		push_warning("Unknown team layer: %s" % source_team)
	
	var mask: int = 0
	var same_team_mask: int = 0
	var other_team_mask: int = 0
	
	for target_sublayer: int in PhysicsSublayer.Type.values():
		var flags: int = ruleset.get_flags(source_sublayer, target_sublayer)
		if flags & (PhysicsInteractionFlag.Type.SAME_TEAM_LAYER if collision_side == CollisionSide.COLLISION_LAYER else PhysicsInteractionFlag.Type.SAME_TEAM_MASK):
			same_team_mask |= 1 << target_sublayer
		if flags & (PhysicsInteractionFlag.Type.OTHER_TEAM_LAYER if collision_side == CollisionSide.COLLISION_LAYER else PhysicsInteractionFlag.Type.OTHER_TEAM_MASK):
			other_team_mask |= 1 << target_sublayer
	
	for team_index: int in layer_controller.layers.values():
		mask |= other_team_mask << team_index
	mask |= same_team_mask << layer_controller.get_layer_offset(source_team)
	
	return mask

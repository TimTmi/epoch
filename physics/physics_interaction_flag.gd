class_name PhysicsInteractionFlag


enum Type {
	NONE = 0,
	
	SAME_TEAM_LAYER = 1 << 0,
	SAME_TEAM_MASK = 1 << 1,
	OTHER_TEAM_LAYER = 1 << 2,
	OTHER_TEAM_MASK = 1 << 3,
	
	ALL = SAME_TEAM_LAYER | SAME_TEAM_MASK | OTHER_TEAM_LAYER | OTHER_TEAM_MASK
}

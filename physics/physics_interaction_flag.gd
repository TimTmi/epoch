class_name PhysicsInteractionFlag


enum Type {
	NONE = 0,
	SAME_TEAM = 1 << 0,
	OTHER_TEAM = 1 << 1,
	ALL = SAME_TEAM | OTHER_TEAM
}

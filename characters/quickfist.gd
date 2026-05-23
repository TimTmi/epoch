extends Character


func _ready():
	$RepulsionField.add_collision_exception(team)
	#set_collision_layer(pow(2, 32) - 1)
	#add_collision_exception_with($RepulsionField);
	#PhysicsServer2D.body_add_collision_exception($RepulsionField.get_rid(), get_rid())

extends Camera2D


@onready var world = get_node("/root/GlobalManager").world
@onready var parent = get_parent()

func _ready():
	parent.tree_exiting.connect(_on_parent_exiting_tree)


func _on_parent_exiting_tree():
	position = parent.position
	get_parent().remove_child(self)
	world.add_child.call_deferred(self)

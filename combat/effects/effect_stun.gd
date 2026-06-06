extends Effect


func _ready():
	character.set_input(false)

func _exit_tree():
	character.set_input(true)

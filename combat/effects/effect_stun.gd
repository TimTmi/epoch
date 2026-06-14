extends Effect


func _ready():
	character.lock_input()

func _exit_tree():
	character.unlock_input()

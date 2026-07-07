class_name InputProvider


var character: Character


func _init(character: Character) -> void:
	self.character = character

func handle_input(_event: InputEvent) -> void:
	pass

func tick(_delta: float) -> void:
	pass

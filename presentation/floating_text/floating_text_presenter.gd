class_name FloatingTextPresenter


var FLOATING_TEXT: PackedScene = preload("uid://b3vndm3ppg4d3")

var floating_texts_container: Node2D


func _init(floating_texts_container: Node2D) -> void:
	self.floating_texts_container = floating_texts_container

func show_text(text: String, config: FloatingTextConfig, position: Vector2) -> void:
	var floating_text: FloatingText = FLOATING_TEXT.instantiate()
	floating_texts_container.add_child(floating_text)
	floating_text.position = position
	floating_text.display(text, config)

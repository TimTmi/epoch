extends SceneTree


var frames := 0


func _initialize() -> void:
	var world: Node = load("res://world/world.tscn").instantiate()
	root.add_child(world)
	current_scene = world

func _process(_delta: float) -> bool:
	frames += 1
	match frames:
		10:
			for character: Character in current_scene.get_node("Characters").get_children():
				character.health.lose(character.health.current)
		30:
			var screen: GameOverScreen = current_scene.get_node("CanvasLayer/UI/GameOverScreen")
			print("screen visible: ", screen.visible)
			print("result: ", screen.get_node("%Result").text)
			print("tree paused: ", paused)
			quit()
	return false

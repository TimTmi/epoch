extends Character


var time: float = 0


func _physics_process(_delta):
	if time < 0.5:
		time += _delta
	else:
		health.current += 1
		time = 0

extends Character


var time: float = 0


func _physics_process(delta):
	super(delta)
	if time < 0.5:
		time += delta
	else:
		receive_healing(HealingContext.new(self, self, 1))
		time = 0

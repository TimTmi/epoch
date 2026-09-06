class_name EvasiveAI extends AIInput


func tick(delta: float) -> void:
	var threat: Projectile = sense_threat(delta)
	if threat != null:
		dodge(threat)
		return
	wander()

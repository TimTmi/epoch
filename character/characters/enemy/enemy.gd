extends Character

 
@onready var punch_area = $PunchArea
@onready var enemies: Array[Character] = []
#var time = 0
var punchable: bool = false


#func _character_added(character):
	#if character.team != team:
		#enemies.append(character)

func _on_dead():
	queue_free()

func _on_body_entered_punch_area(body):
	if body is Character and body.team != team:
		punchable = true

func _on_body_exited_punch_area(body):
	if body is Character and body.team != team:
		punchable = false

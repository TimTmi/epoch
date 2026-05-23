extends TextureProgressBar


var move: Move:
	set(new_move):
		move = new_move
		texture_progress = move.icon
		$Icon.texture = move.icon
		max_value = move.wait_time
		value = 0
		move.started.connect(_on_move_started)
		move.ended.connect(_on_move_ended)
		move.timeout.connect(_on_move_cooldown_finished)
		move.user.tree_exiting.connect(_on_character_tree_exiting)


func _ready():
	set_process(false)

func _process(_delta):
	value = move.time_left

func _on_move_started():
	value = move.wait_time

func _on_move_ended():
	set_process(true)

func _on_move_cooldown_finished():
	value = 0
	set_process(false)

func _on_character_tree_exiting():
	set_process(false)

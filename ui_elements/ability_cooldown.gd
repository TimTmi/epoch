extends TextureProgressBar


var ability: Ability:
	set(new_ability):
		ability = new_ability
		texture_progress = ability.icon
		$Icon.texture = ability.icon
		max_value = ability.wait_time
		value = 0
		ability.started.connect(_on_ability_started)
		ability.ended.connect(_on_ability_ended)
		ability.timeout.connect(_on_ability_cooldown_finished)
		ability.user.tree_exiting.connect(_on_character_tree_exiting)


func _ready():
	set_process(false)

func _process(_delta):
	value = ability.time_left

func _on_ability_started():
	value = ability.wait_time

func _on_ability_ended():
	set_process(true)

func _on_ability_cooldown_finished():
	value = 0
	set_process(false)

func _on_character_tree_exiting():
	set_process(false)

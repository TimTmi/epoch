class_name AbilityCard extends TextureProgressBar


@onready var icon: TextureRect = $Icon

var instance: AbilityInstance


func setup(instance: AbilityInstance) -> void:
	self.instance = instance
	
	var ability: Ability = instance.ability
	
	texture_progress = ability.icon
	icon.texture = ability.icon
	max_value = ability.cooldown
	value = 0
	instance.started.connect(_on_ability_started)
	instance.ended.connect(_on_ability_ended)

func _ready() -> void:
	set_process(false)

func _process(_delta) -> void:
	value = instance.cooldown_remaining
	if value <= 0.0:
		set_process(false)

func _on_ability_started() -> void:
	value = instance.ability.cooldown

func _on_ability_ended() -> void:
	set_process(true)

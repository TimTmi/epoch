extends RigidBody2D
class_name Character


const DAMAGE_TEXT = preload("res://damage_text.tscn")

@onready var world = get_parent()
@onready var moves = $Moves
@onready var controller = $Controller
@onready var health: Stat = $Health
@onready var attack_percent: Stat = $AttackPercent
@onready var attack_flat: Stat = $AttackFlat
@onready var defense_percent: Stat = $DefensePercent
@onready var defense_flat: Stat = $DefenseFlat

@export var init_speed: float = 1000
@onready var speed: float = init_speed
var positions : PackedVector2Array = []
var time_scale: float = 1
var input_disabled: int = 0:
	set(value):
		input_disabled += int(value) * 2 - 1
		set_process_unhandled_input(!input_disabled)
var team: int = 0:
	set(value):
		team = value
		set_collision_layer_value(value, true)
		set_collision_mask_value(value, true)
var effects = preload("res://effects/effects.gd").new()


#signal health_changed(old_value: int, new_value: int)
#signal damage_dealt(amount: float)
#signal damage_taken(amount: float)
#signal healed(amount: float)
signal dead


func _ready():
	effects.name = "Effects"
	add_child(effects)
	add_to_group("characters")
	#get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, "characters", "_character_added", self)
	ready()

func ready():
	pass

func set_input(enable: bool) -> void:
	input_disabled = !enable

func use_move(move_name, input) -> void:
	var move = moves.get_node_or_null(move_name)
	if move != null:
		move.use(input)

func push(force: Vector2):
	apply_central_impulse(force * time_scale)

func move(direction: Vector2) -> void:
	direction = direction.normalized() * speed * time_scale
	apply_central_force(direction)

func set_health(value: float) -> void:
	$SetHealth.function.call(value, self)

func deal_damage(amount: float, target: Character) -> void:
	$DealDamage.function.call(amount, self, target)

func take_damage(amount: float, attacker: Character) -> void:
	$TakeDamage.function.call(amount, attacker, self)

func heal(amount: float, healer: Character = self) -> void:
	$Heal.function.call(amount, healer, self)

func apply_effect(effect: Effect) -> void:
	effects.apply_effect(effect)

func _on_health_changed(old_value: int, new_value: int):
	var damage_text = DAMAGE_TEXT.instantiate()
	damage_text.text = str(old_value - new_value)
	damage_text.position = position - damage_text.size / 2
	world.add_child(damage_text)
	if new_value == 0:
		dead.emit()

func _on_damage_dealt(_amount: float, _character: Character):
	pass

func _on_damage_taken(_amount: float, _character: Character):
	pass

func _on_healed(_amount: float):
	pass

func _on_dead():
	queue_free()

func _on_attack_percent_changed(_old_stat, new_stat):
	$DealDamage.multiplier = 1 + new_stat * 0.01

func _on_attack_flat_changed(_old_stat, new_stat):
	$DealDamage.flat_modifier = new_stat

func _on_defense_percent_changed(_old_stat, new_stat):
	$TakeDamage.multiplier = 1 - new_stat * 0.01

func _on_defense_flat_changed(_old_stat, new_stat):
	$TakeDamage.flat_modifier = new_stat

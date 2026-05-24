extends Node
class_name Controller


const NAVIGATION_AGENT = preload("uid://c2lbr66wq6kg0")

@export var character: Character
@export var is_player: bool = false
	#set(value):
		#is_player = value

@onready var navigation_agent: NavigationAgent2D


func _unhandled_input(_event):
	if Input.is_action_just_pressed("lmb"):
		character.use_ability("LMB", character.get_global_mouse_position())
	elif Input.is_action_just_pressed("rmb"):
		character.use_ability("RMB", character.get_global_mouse_position())
	elif Input.is_action_just_pressed("shift"):
		character.use_ability("Shift", character.position + character.linear_velocity)
	elif Input.is_action_just_pressed("e"):
		character.use_ability("E", character.get_global_mouse_position())
	elif Input.is_action_just_pressed("q"):
		character.use_ability("Q", character.get_global_mouse_position())

func _ready():
	set_physics_process(false)
	ready.call_deferred()
	if !is_player:
		set_process_unhandled_input(false)
		navigation_agent = NAVIGATION_AGENT.instantiate()
		character.add_child.call_deferred(navigation_agent)
		navigation_agent.velocity_computed.connect(_on_velocity_computed)
	set_physics_process.call_deferred(true)

func ready():
	pass

func move_to(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)
	if navigation_agent.is_navigation_finished():
		return
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = character.global_position.direction_to(next_path_position) * character.speed
	navigation_agent.set_velocity(new_velocity)

func _physics_process(_delta):
	if character.input_disabled:
		return
	if is_player:
		_player_controller()
	else:
		_computer_controller()

func _on_velocity_computed(safe_velocity: Vector2):
	character.move(safe_velocity)

func _player_controller():
	character.move(Input.get_vector("a", "d", "w", "s"))

func _computer_controller():
	pass

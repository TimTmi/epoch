class_name InputController extends Node


const NAVIGATION_AGENT = preload("uid://c2lbr66wq6kg0")

@export_group("Input")
@export var primary_action: String = "primary"
@export var secondary_action: String = "secondary"
@export var utility_action: String = "utility"
@export var special_action: String = "special"
@export var ultimate_action: String = "ultimate"
@export var extra_1_action: String = "extra_1"
@export var extra_2_action: String = "extra_2"
@export var extra_3_action: String = "extra_3"

@export_group("Setup")
@export var character: Character
@export var is_player: bool = false
	#set(value):
		#is_player = value

@onready var navigation_agent: NavigationAgent2D


func _unhandled_input(_event):
	if Input.is_action_just_pressed(primary_action):
		character.try_activate_slot(AbilitySystem.CommandSlot.PRIMARY, AbilityIntent.from_target_position(character.get_global_mouse_position()))
	elif Input.is_action_just_pressed(secondary_action):
		character.try_activate_slot(AbilitySystem.CommandSlot.SECONDARY, AbilityIntent.from_target_position(character.get_global_mouse_position()))
	elif Input.is_action_just_pressed(utility_action):
		character.try_activate_slot(AbilitySystem.CommandSlot.UTILITY, AbilityIntent.from_target_position(character.get_global_mouse_position()))
	elif Input.is_action_just_pressed(special_action):
		character.try_activate_slot(AbilitySystem.CommandSlot.SPECIAL, AbilityIntent.from_target_position(character.get_global_mouse_position()))
	elif Input.is_action_just_pressed(ultimate_action):
		character.try_activate_slot(AbilitySystem.CommandSlot.ULTIMATE, AbilityIntent.from_target_position(character.get_global_mouse_position()))
	elif Input.is_action_just_pressed(extra_1_action):
		character.try_activate_slot(AbilitySystem.CommandSlot.EXTRA_1, AbilityIntent.from_target_position(character.get_global_mouse_position()))
	elif Input.is_action_just_pressed(extra_2_action):
		character.try_activate_slot(AbilitySystem.CommandSlot.EXTRA_2, AbilityIntent.from_target_position(character.get_global_mouse_position()))
	elif Input.is_action_just_pressed(extra_3_action):
		character.try_activate_slot(AbilitySystem.CommandSlot.EXTRA_3, AbilityIntent.from_target_position(character.get_global_mouse_position()))

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
	character.move(Input.get_vector("move_left", "move_right", "move_up", "move_down"))

func _computer_controller():
	pass

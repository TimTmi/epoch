class_name PlayerInput extends InputProvider


var move_up_action: StringName = "move_up"
var move_left_action: StringName = "move_left"
var move_down_action: StringName = "move_down"
var move_right_action: StringName = "move_right"

var primary_action: StringName = "primary"
var secondary_action: StringName = "secondary"
var utility_action: StringName = "utility"
var special_action: StringName = "special"
var ultimate_action: StringName = "ultimate"
var extra_1_action: StringName = "extra_1"
var extra_2_action: StringName = "extra_2"
var extra_3_action: StringName = "extra_3"

var action_to_slot: Dictionary = {
	primary_action: AbilitySystem.CommandSlot.PRIMARY,
	secondary_action: AbilitySystem.CommandSlot.SECONDARY,
	utility_action: AbilitySystem.CommandSlot.UTILITY,
	special_action: AbilitySystem.CommandSlot.SPECIAL,
	ultimate_action: AbilitySystem.CommandSlot.ULTIMATE,
	extra_1_action: AbilitySystem.CommandSlot.EXTRA_1,
	extra_2_action: AbilitySystem.CommandSlot.EXTRA_2,
	extra_3_action: AbilitySystem.CommandSlot.EXTRA_3,
}


func handle_input(event: InputEvent) -> void:
	for action in action_to_slot:
		if event.is_action_pressed(action):
			character.try_activate_slot(
				action_to_slot[action],
				AbilityIntent.from_target_position(character.get_global_mouse_position())
			)
			break

func tick(_delta: float) -> void:
	character.move(Input.get_vector(move_left_action, move_right_action, move_up_action, move_down_action))

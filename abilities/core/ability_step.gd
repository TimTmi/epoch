class_name AbilityStep extends Resource


enum Trigger { CLICK, HOLD, WAIT }
enum AdvanceMode { DISCARD, DEFER }


@export var trigger: Trigger = Trigger.CLICK
@export var cooldown: float = -1.0  # -1 inherits the ability's cooldown
@export var advance_mode: AdvanceMode = AdvanceMode.DISCARD  # advance() while on cooldown: discard it, or defer until ready

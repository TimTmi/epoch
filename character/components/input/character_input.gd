class_name CharacterInput


var character: Character
var provider: InputProvider

var _locks: int = 0


func _init(character: Character, provider_script: GDScript) -> void:
	if provider_script == null:
		provider_script = InputProvider
		push_error("[character %s (%s)] input script is not set" %[character.name, character.get_instance_id()])
	
	var object: Object = provider_script.new(character)
	if not object is InputProvider:
		object = InputProvider.new(character)
		push_error("[character %s (%s)] input script is not of type CharacterInput" %[character.name, character.get_instance_id()])
	
	provider = object

func lock() -> void:
	_locks += 1

func unlock() -> void:
	if _locks <= 0:
		push_warning("[character %s (%s)] there is nothing to unlock" %[character.name, character.get_instance_id()])
		return
	
	_locks -= 1

func is_locked() -> bool:
	return _locks > 0

func handle_input(event: InputEvent) -> void:
	if is_locked():
		return
	
	provider.handle_input(event)

func tick(delta: float) -> void:
	if is_locked():
		return
	
	provider.tick(delta)

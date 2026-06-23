class_name Rage extends Ability


const AFTERIMAGE = preload("uid://bcph033gu3bmn")

@export var duration: float = 10
@export var damage_on_self: float = 50


func activate(context: AbilityContext) -> void:
	var caster: AbilityCaster = context.caster
	
	var afterimage = caster.spawn_vfx(AFTERIMAGE)
	var tween: Tween = afterimage.create_tween()
	var damage_interval: float = duration / damage_on_self
	var take_damage_function: ComponentFunction = caster.character.get_node("TakeDamage")
	var take_damage_override_function = func(_value: float):
		return 1
	take_damage_function.add_handler(take_damage_override_function)
	#take_damage_function.handlers.append(take_damage_override_function)
	for i in damage_on_self:
		tween.tween_callback(caster.damage_self.bind(1))
		tween.tween_interval(damage_interval)
	
	#tween.tween_callback(take_damage_function.handlers.erase.bind(take_damage_override_function))
	tween.tween_callback(take_damage_function.remove_handler.bind(take_damage_override_function))
	tween.tween_callback(afterimage.queue_free)
	
	await tween.finished

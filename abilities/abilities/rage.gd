class_name Rage extends Ability


const AFTERIMAGE = preload("uid://bcph033gu3bmn")

@export var duration: float = 10
@export var self_damage: float = 50


func activate(context: AbilityContext) -> void:
	var user: Character = context.user
	var combat: CombatSystem = context.combat
	
	var afterimage = user.spawn_vfx(AFTERIMAGE)
	var tween: Tween = afterimage.create_tween()
	var damage_interval: float = duration / self_damage
	var steel_skin_effect: Effect = SteelSkinEffect.new()
	combat.add_effect(user, steel_skin_effect)
	#take_damage_function.handlers.append(take_damage_override_function)
	for i in self_damage:
		tween.tween_callback(combat.deal_damage.bind(user, user, 1))
		tween.tween_interval(damage_interval)
	
	tween.tween_callback(user.remove_effect.bind(steel_skin_effect))
	tween.tween_callback(afterimage.queue_free)
	
	await tween.finished

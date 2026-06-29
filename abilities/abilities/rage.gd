class_name Rage extends Ability


const AFTERIMAGE = preload("uid://bcph033gu3bmn")

@export var duration: float = 10
@export var self_damage: float = 50


class DamageReceivedCapped extends CombatRule:
	func before_damage_taken(context: DamageContext) -> void:
		context.amount = max(1, context.amount)


func activate(context: AbilityContext) -> void:
	var user: Character = context.user
	var combat: CombatSystem = context.combat
	
	var afterimage = user.spawn_vfx(AFTERIMAGE)
	var tween: Tween = afterimage.create_tween()
	var damage_interval: float = duration / self_damage
	var rule: CombatRule = DamageReceivedCapped.new()
	combat.add_rule(user, rule)
	#take_damage_function.handlers.append(take_damage_override_function)
	for i in self_damage:
		tween.tween_callback(combat.deal_damage.bind(user, user, 1))
		tween.tween_interval(damage_interval)
	
	tween.tween_callback(combat.remove_rule.bind(user, rule))
	tween.tween_callback(afterimage.queue_free)
	
	await tween.finished

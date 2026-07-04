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
	var rule: CombatRule = CombatRule.new(
		RuleKey.new(user, RuleKey.Phase.BEFORE, RuleKey.Hook.DAMAGE_TAKEN),
		func(context: DamageContext) -> void:
			context.amount = min(1, context.amount)
	)
	#var rule: CombatRule = CombatRule.new(
		#RuleKey.new(user, RuleKey.Phase.BEFORE, RuleKey.Hook.DAMAGE_DEALT),
		#func(context: DamageContext) -> void:
			#context.amount *= 2
	#)
	var rules: Array[CombatRule] = [rule]
	combat.add_rules(rules)
	#take_damage_function.handlers.append(take_damage_override_function)
	for i in self_damage:
		tween.tween_callback(combat.deal_damage.bind(user, user, 1))
		tween.tween_interval(damage_interval)
	
	tween.tween_callback(combat.remove_rules.bind(rules))
	tween.tween_callback(afterimage.queue_free)
	
	await tween.finished

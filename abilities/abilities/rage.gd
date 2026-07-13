class_name Rage extends Ability


const AFTERIMAGE = preload("uid://bcph033gu3bmn")

@export var duration: float = 10
@export var self_damage: float = 50


func activate(context: AbilityContext) -> void:
	var user: Character = context.user
	
	var afterimage = user.spawner.spawn_vfx(AFTERIMAGE)
	var tween: Tween = afterimage.create_tween()
	var damage_interval: float = duration / self_damage
	var rule: Rule = Rule.new(
		Rule.Phase.BEFORE,
		user.deal_damage,
		func(damage_context: DamageContext) -> void:
			damage_context.amount = min(1, damage_context.amount)
	)
	#var rule: Rule = Rule.new(
		#RuleKey.new(user, RuleKey.Phase.BEFORE, RuleKey.Hook.DAMAGE_DEALT),
		#func(context: DamageContext) -> void:
			#context.amount *= 2
	#)
	var rules: Array[Rule] = [rule]
	#combat.add_rules(rules)
	user.health.rule_system.add_rule(rule)
	#take_damage_function.handlers.append(take_damage_override_function)
	for i in self_damage:
		tween.tween_callback(user.health.lose.bind(1))
		tween.tween_interval(damage_interval)
	
	tween.tween_callback(user.health.rule_system.remove_rule.bind(rule))
	tween.tween_callback(afterimage.queue_free)
	
	await tween.finished

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
		user,
		RuleEvent.new(RuleEvent.Phase.BEFORE, Character, Character.Event.DAMAGE_DEALT),
		Rule.Target.ENEMY,
		[],
		[MultiplyDamageDealt.new(2.0)]
	)
	var rule_instance: RuleInstance = RuleInstance.new(user, rule)
	var rules: Array[Rule] = [rule]
	#combat.add_rules(rules)
	user.rules.add_rule(rule_instance)
	#take_damage_function.handlers.append(take_damage_override_function)
	for i in self_damage:
		tween.tween_callback(user.health.lose.bind(1))
		tween.tween_interval(damage_interval)
	
	tween.tween_callback(user.rules.remove_rule.bind(rule_instance))
	tween.tween_callback(afterimage.queue_free)
	
	await tween.finished

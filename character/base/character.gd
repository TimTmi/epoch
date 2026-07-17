extends RigidBody2D
class_name Character


enum Event {
	DAMAGE_DEALT,
	DAMAGE_TAKEN,
	HEALED,
	HEALING_RECEIVED,
	DEAD,
	STATUS_EFFECT_APPLIED,
	STATUS_EFFECT_RECEIVED
}


var team: StringName
var physics_profile: PhysicsProfile

var world_context: WorldContext

var health: CharacterHealth
var speed: CharacterStat
var input: CharacterInput
var spawner: CharacterSpawner
var abilities: AbilitySystem
var status_effects: StatusEffectSystem
var rules: RuleSystem

var positions : PackedVector2Array = []
var time_scale: float = 1


func initialize(world_context: WorldContext, config: CharacterConfig, team: StringName, physics_profile: PhysicsProfile) -> void:
	self.world_context = world_context
	self.team = team
	self.physics_profile = physics_profile
	
	config_physics()
	setup_stats(config.stats)
	input = CharacterInput.new(self, config.input_script)
	spawner = CharacterSpawner.new(self, world_context)
	abilities = AbilitySystem.new(config.slot_abilities, config.passive_abilities)
	status_effects = StatusEffectSystem.new(self)
	rules = RuleSystem.new()

func config_physics() -> void:
	collision_layer = physics_profile.character_layer
	collision_mask = physics_profile.character_mask

func setup_stats(config: StatsConfig) -> void:
	setup_health(config.health)
	speed = CharacterStat.new(self, config.speed)

func setup_health(config: StatConfig) -> void:
	health = CharacterHealth.new(self, config)
	health.changed.connect(world_context.combat_events.health_changed.emit)
	health.changed.connect(_on_health_changed)

func get_effective_delta(delta: float) -> float:
	return delta * time_scale

func _unhandled_input(event: InputEvent) -> void:
	input.handle_input(event)

func deal_damage(target: Character, amount: float) -> void:
	rules.process(
		self, Character, Event.DAMAGE_DEALT, DamageContext.new(self, target, amount),
		func(context: DamageContext):
			context.target.take_damage(context)
	)

func take_damage(context: DamageContext) -> void:
	rules.process(
		self, Character, Event.DAMAGE_TAKEN, context,
		func(context: DamageContext): context.target.health.lose(context.amount)
	)

func heal(target: Character, amount: float) -> void:
	rules.process(
		self, Character, Event.HEALED, HealingContext.new(self, target, amount),
		func(context: HealingContext): context.target.receive_healing(context)
	)

func receive_healing(context: HealingContext) -> void:
	rules.process(
		self, Character, Event.HEALING_RECEIVED, context,
		func(context: HealingContext): context.target.health.gain(context.amount)
	)

func die() -> void:
	rules.process(
		self, Character, Event.DEAD, DeathContext.new(self),
		func(context: DeathContext):
			if context.dead:
				queue_free()
	)

func apply_status_effect(target: Character, effect: StatusEffect) -> void:
	rules.process(
		self, Character, Event.STATUS_EFFECT_APPLIED, StatusEffectApplicationContext.new(self, target, effect),
		func(context: StatusEffectApplicationContext):
			if context.effect != null:
				context.target.receive_status_effect(context)
	)

func receive_status_effect(context: StatusEffectApplicationContext) -> void:
	rules.process(
		self, Character, Event.STATUS_EFFECT_RECEIVED, context,
		func(context: StatusEffectApplicationContext):
			if context.effect != null:
				context.target.status_effects.apply_status_effect(context)
	)

func try_activate_ability(ability: Ability, intent: AbilityIntent) -> void:
	abilities.try_activate_ability(ability, intent, self)

func try_activate_slot(slot: AbilitySystem.CommandSlot, intent: AbilityIntent) -> void:
	abilities.try_activate_slot(slot, intent, self, world_context.combat_events)

func is_same_team(character: Character) -> bool:
	return team == character.team

func push(target: Character, force: Vector2):
	target.apply_central_impulse(force * time_scale)

func move(direction: Vector2) -> void:
	direction = direction.normalized() * speed.current * time_scale
	apply_central_force(direction)

func _physics_process(delta: float) -> void:
	input.tick(delta)
	abilities.tick(delta)
	status_effects.tick(delta)

func _on_health_changed(context: StatChangeContext) -> void:
	if context.new_stat <= health.minimum:
		die()

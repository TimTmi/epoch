class_name Stomp extends Ability


const SHOCKWAVE = preload("uid://bgtgir2b55nv4")

@export var damage: int = 10
@export var radius: int = 32
@export var duration: float = 0.5
@export var knockback_force: int = 300
@export var stun_duration: float = 1


func activate(context: AbilityContext) -> void:
	var user: Character = context.user
	var combat: CombatSystem = context.combat
	
	var shockwave: Shockwave = user.spawner.spawn_local_hitbox(SHOCKWAVE)
	shockwave.body_entered.connect(_on_body_entered.bind(user, combat))
	user.input.lock()
	await shockwave.finished
	user.input.unlock()

func _on_body_entered(body: Node, user: Character, combat: CombatSystem):
	if not body is Character or user.is_same_team(body):
		return
	
	var target: Character = body
	var user_global_position: Vector2 = user.get_global_position()
	var direction = (target.global_position - user_global_position).normalized()
	
	combat.deal_damage(user, target, damage)
	user.push(target, direction * (knockback_force ** 2) / user_global_position.distance_squared_to(target.global_position))
	
	var stun: StatusEffect = Stun.new(stun_duration)
	combat.apply_status_effect(user, target, stun)

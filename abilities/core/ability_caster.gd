class_name AbilityCaster


var character: Character


func _init(character: Character) -> void:
	self.character = character

func get_global_position() -> Vector2:
	return character.global_position

func spawn_local_hitbox(scene: PackedScene) -> Hitbox:
	return character.spawn_local_hitbox(scene)

func spawn_projectile(scene: PackedScene) -> Projectile:
	return character.spawn_projectile(scene)

func spawn_vfx(scene: PackedScene) -> Node2D:
	return character.spawn_vfx(scene)

func lock_input() -> void:
	character.lock_input()

func unlock_input() -> void:
	character.unlock_input()

func disable_input(duration: float) -> void:
	lock_input()
	var timer: Timer = Timer.new()
	character.add_child(timer)
	timer.wait_time = duration
	timer.timeout.connect(unlock_input)
	timer.start()

func impulse(force: Vector2) -> void:
	character.apply_central_impulse(force)

func is_same_team(body: Node) -> bool:
	return body is Character and body.team == character.team

func deal_damage(amount: float, target: Character) -> void:
	character.deal_damage(amount, target)

func damage_self(amount: float) -> void:
	character.take_damage(amount, character)

func push(target: Character, force: Vector2) -> void:
	target.push(force)

func apply_effect(effect: StatusEffect, target: Character) -> void:
	character.apply_effect(effect, target)

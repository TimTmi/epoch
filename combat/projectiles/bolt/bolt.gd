class_name Bolt extends Projectile


signal hit(body: Node2D)


@export var max_lifetime: float = 4.0

var _has_hit: bool = false
var _remaining_lifetime: float


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	_remaining_lifetime = max_lifetime
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	_remaining_lifetime -= delta
	if _remaining_lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if _has_hit:
		return
	_has_hit = true
	hit.emit(body)
	queue_free()

class_name CharacterStats


var health: Stat
var speed: Stat


func _init(config: StatsConfig) -> void:
	health = Stat.new(config.health)
	speed = Stat.new(config.speed)

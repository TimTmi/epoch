class_name HealthChangeContext


var combat: CombatSystem
var character: Character
var old_health: float
var new_health: float


func _init(combat: CombatSystem, character: Character, old_health: float, new_health: float) -> void:
	self.combat = combat
	self.character = character
	self.old_health = old_health
	self.new_health = new_health

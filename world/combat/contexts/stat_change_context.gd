class_name StatChangeContext


var character: Character
var old_stat: float
var new_stat: float


func _init(character: Character, old_stat: float, new_stat: float) -> void:
	self.character = character
	self.old_stat = old_stat
	self.new_stat = new_stat

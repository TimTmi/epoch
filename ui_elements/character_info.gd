extends VBoxContainer


const ABILITY_CARD = preload("res://ui_elements/AbilityCard.tscn")

@onready var character_name = $VBoxContainer/Name
@onready var health = $VBoxContainer/Health
@onready var abilities = $Abilities


func set_up_info(character: Character):
	character_name.text = character.name
	health.custom_minimum_size.x = character.health.value
	health.max_value = character.health.value
	health.value = character.health.value
	character.health.stat_changed.connect(_on_health_changed)
	
	for slot: AbilitySystem.CommandSlot in character.ability_system.slot_ability_instances:
		var instance: AbilityInstance = character.ability_system.slot_ability_instances.get(slot)
		
		var card: AbilityCard = ABILITY_CARD.instantiate()
		abilities.add_child(card)
		card.setup(instance)

func _on_health_changed(_old_value: float, new_value: float):
	health.value = new_value

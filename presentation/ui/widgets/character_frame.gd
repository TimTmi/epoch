class_name CharacterFrame extends VBoxContainer


const ABILITY_CARD = preload("uid://cm35bklqb0tb1")

@onready var character_name = $VBoxContainer/Name
@onready var health = $VBoxContainer/Health
@onready var abilities = $Abilities


func set_up_info(character: Character):
	#await character.initialized
	
	character_name.text = character.name
	health.custom_minimum_size.x = character.stats.health.maximum
	health.max_value = character.stats.health.maximum
	health.value = character.stats.health.current
	character.stats.health.stat_changed.connect(_on_health_changed)
	
	for slot: AbilitySystem.CommandSlot in character.abilities.slot_ability_instances:
		var instance: AbilityInstance = character.abilities.slot_ability_instances.get(slot)
		
		var card: AbilityCard = ABILITY_CARD.instantiate()
		abilities.add_child(card)
		card.setup(instance)

func _on_health_changed(_old_value: float, new_value: float):
	health.value = new_value

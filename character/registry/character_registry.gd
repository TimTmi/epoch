class_name CharacterRegistry extends Resource


@export var characters: Array[CharacterConfig]


func get_character(id: StringName) -> CharacterConfig:
	for character: CharacterConfig in characters:
		if character.id == id:
			return character
	
	return null

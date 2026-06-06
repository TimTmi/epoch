class_name World extends Node2D


const CAMERA = preload("uid://dskry0mydaydk")
const DAMAGE_TEXT = preload("uid://b3vndm3ppg4d3")

@export var character_registry: CharacterRegistry
@export var layer_controller: PhysicsLayerController
@export var mask_resolver: PhysicsMaskResolver

@export var teams: Array[TeamConfig]
@export var player_team: StringName
@export var player_character: StringName

@onready var characters_container: Node2D = $Characters
@onready var projectiles_container: Node2D = $Projectiles
@onready var spawner: Spawner = $Spawner
@onready var UI = $CanvasLayer/UI


func _ready():
	randomize()
	
	spawner.setup(mask_resolver, characters_container, projectiles_container)
	register_teams()
	
	for team: TeamConfig in teams:
		for id: StringName in team.members:
			var config: CharacterConfig = character_registry.get_character(id)
			var character: Character = config.scene.instantiate()
			add_character(character, team.name)
			character.apply_config(config)
			
			if player_team == team.name and player_character == config.id:
				var camera = CAMERA.instantiate()
				character.add_child(camera)
				character.add_to_group("player")

func register_teams() -> void:
	for team: TeamConfig in teams:
		layer_controller.add_layer(team.name)

func add_character(character: Character, team: StringName):
	spawner.spawn_character(character, team)
	UI.add_character_info(character)

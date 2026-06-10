class_name World extends Node2D


const DAMAGE_TEXT = preload("uid://b3vndm3ppg4d3")

@export var character_registry: CharacterRegistry
@export var layer_controller: PhysicsLayerController
@export var mask_resolver: PhysicsMaskResolver

@export var teams: Array[TeamConfig]
@export var player_team: StringName
@export var player_character: StringName

@onready var characters_container: Node2D = $Characters
@onready var projectiles_container: Node2D = $Projectiles
@onready var hitboxes_container: Node2D = $Hitboxes
@onready var floating_texts_container: Node2D = $Effects/FloatingTexts
@onready var spawner: Spawner = $Spawner
@onready var UI = $CanvasLayer/UI


func _ready():
	randomize()
	
	var spawn_service: SpawnService = SpawnService.new(self)
	var world_context: WorldContext = WorldContext.new(self, spawn_service)
	
	spawner.setup(world_context, mask_resolver, characters_container, projectiles_container)
	register_teams()
	
	for team: TeamConfig in teams:
		for id: StringName in team.members:
			var config: CharacterConfig = character_registry.get_character(id)
			var character: Character = spawn_character(config, team.name)
			
			if player_team == team.name and player_character == config.id:
				character.add_to_group("player")

func register_teams() -> void:
	for team: TeamConfig in teams:
		layer_controller.add_layer(team.name)

func spawn_character(config: CharacterConfig, team: StringName) -> Character:
	var character: Character = spawner.spawn_character(config, team)
	UI.add_character_info(character)
	return character

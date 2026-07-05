class_name World extends Node2D


@export var character_registry: CharacterRegistry
@export var layer_controller: PhysicsLayerController
@export var mask_resolver: PhysicsMaskResolver
@export var combat_floating_text_configs: CombatFloatingTextConfigs

@export var teams: Array[TeamConfig]
@export var player_team: StringName
@export var player_character: StringName

@onready var characters_container: Node2D = $Characters
@onready var projectiles_container: Node2D = $Projectiles
@onready var hitboxes_container: Node2D = $Hitboxes
@onready var floating_texts_container: Node2D = $Effects/FloatingTexts
@onready var spawner: Spawner = $Spawner
@onready var UI = $CanvasLayer/UI

var spawn_service: SpawnService
var combat_system: CombatSystem
var floating_text_presenter: FloatingTextPresenter
var combat_floating_text_presenter: CombatFloatingTextPresenter
var world_context: WorldContext


func _ready() -> void:
	randomize()
	setup_services()
	setup_spawner()
	connect_events()
	setup_teams()
 
func setup_services() -> void:
	spawn_service = SpawnService.new(spawner)
	combat_system = CombatSystem.new()
	floating_text_presenter = FloatingTextPresenter.new(floating_texts_container)
	combat_floating_text_presenter = CombatFloatingTextPresenter.new(floating_text_presenter, combat_floating_text_configs)
	world_context = WorldContext.new(self, spawn_service, combat_system)

func setup_spawner() -> void:
	spawner.setup(world_context, mask_resolver, characters_container, projectiles_container, hitboxes_container)

func connect_events() -> void:
	spawn_service.character_spawned.connect(_on_character_spawned)
	combat_floating_text_presenter.bind(combat_system)

func setup_teams() -> void:
	register_teams()
	for team: TeamConfig in teams:
		spawn_team(team)

func spawn_team(team: TeamConfig) -> void:
	for id: StringName in team.members:
		var config: CharacterConfig = character_registry.get_character(id)
		spawn_team_member(config, team.name)

func spawn_team_member(config: CharacterConfig, team_name: StringName) -> Character:
	if character_is_player(config, team_name):
		config.input_script = PlayerInput
	return spawn_service.spawn_character(config, team_name)

func character_is_player(config: CharacterConfig, team_name: StringName) -> bool:
	return player_team == team_name and player_character == config.id

func register_teams() -> void:
	for team: TeamConfig in teams:
		register_team(team.name)

func register_team(team_name: StringName) -> bool:
	return layer_controller.add_layer(team_name)

func _on_character_spawned(character: Character) -> void:
	UI.add_character_info(character)

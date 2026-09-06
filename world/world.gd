class_name World extends Node2D


const TEAM_SIDE_OFFSET := 192.0

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
@onready var strands_container: Node2D = $Strands
@onready var obstacles_container: Node2D = $Obstacles
@onready var floating_texts_container: Node2D = $Effects/FloatingTexts
@onready var spawner: Spawner = $Spawner
@onready var UI: Control = $CanvasLayer/UI
@onready var walls: TileMapLayer = $Walls

var spawn_service: SpawnService
var combat_events: CombatEvents
var floating_text_presenter: FloatingTextPresenter
var combat_floating_text_presenter: CombatFloatingTextPresenter
var world_services: WorldServices


func _ready() -> void:
	randomize()
	setup_services()
	setup_spawner()
	connect_events()
	setup_environment()
	setup_teams()

func setup_services() -> void:
	spawn_service = SpawnService.new(spawner)
	combat_events = CombatEvents.new()
	floating_text_presenter = FloatingTextPresenter.new(floating_texts_container)
	combat_floating_text_presenter = CombatFloatingTextPresenter.new(floating_text_presenter, combat_floating_text_configs)
	world_services = WorldServices.new(self, spawn_service, combat_events)

func setup_spawner() -> void:
	spawner.setup(world_services, mask_resolver)

func connect_events() -> void:
	spawn_service.character_spawned.connect(_on_character_spawned)
	combat_floating_text_presenter.bind(combat_events)

func setup_environment() -> void:
	layer_controller.add_layer(&"environment")
	var tile_set: TileSet = walls.tile_set
	tile_set.set_physics_layer_collision_layer(0, mask_resolver.get_layer(&"environment", PhysicsSublayer.Type.WALL))
	tile_set.set_physics_layer_collision_mask(0, mask_resolver.get_mask(&"environment", PhysicsSublayer.Type.WALL))

func setup_teams() -> void:
	if GameSession.has_lineup():
		setup_session_lineup()
		return
	register_teams()
	for team: TeamConfig in teams:
		spawn_team(team)

func setup_session_lineup() -> void:
	player_team = &"player"
	player_character = GameSession.player_character
	register_team(&"player")
	register_team(&"enemy")
	spawn_team_member(character_registry.get_character(GameSession.player_character), &"player", Vector2(-TEAM_SIDE_OFFSET, 0))
	spawn_team_member(character_registry.get_character(GameSession.enemy_character), &"enemy", Vector2(TEAM_SIDE_OFFSET, 0))

func spawn_team(team: TeamConfig) -> void:
	for id: StringName in team.members:
		var config: CharacterConfig = character_registry.get_character(id)
		spawn_team_member(config, team.name)

func spawn_team_member(config: CharacterConfig, team_name: StringName, position: Vector2 = Vector2.ZERO) -> Character:
	if character_is_player(config, team_name):
		config = config.duplicate()
		config.input_script = PlayerInput
	return spawn_service.spawn_character(config, team_name, position)

func character_is_player(config: CharacterConfig, team_name: StringName) -> bool:
	return player_team == team_name and player_character == config.id

func register_teams() -> void:
	for team: TeamConfig in teams:
		register_team(team.name)

func register_team(team_name: StringName) -> bool:
	return layer_controller.add_layer(team_name)

func _on_character_spawned(character: Character) -> void:
	UI.add_character_info(character)

extends Node2D


const CAMERA = preload("uid://dskry0mydaydk")
const DAMAGE_TEXT = preload("uid://b3vndm3ppg4d3")

@export var character_registry: CharacterRegistry

@export var teams: Array[TeamConfig]
@export var player_team: int
@export var player_character: StringName

@onready var global_manager = get_node("/root/GlobalManager")
@onready var UI = $CanvasLayer/UI

var player: String = "quickfist"
var enemies: Array[String] = ["enemy"]
#var characters = ["quickfist"]


func _ready():
	randomize()
	
	global_manager.world = self
	
	for team: TeamConfig in teams:
		for id: StringName in team.members:
			var config: CharacterConfig = character_registry.get_character(id)
			var character: Character = config.scene.instantiate()
			add_character(character, team.id)
			character.apply_config(config)
			
			if player_team == team.id and player_character == config.id:
				var camera = CAMERA.instantiate()
				character.add_child(camera)
				character.add_to_group("player")
	
	#var character = load("res://characters/%s.tscn" %player).instantiate()
	#var camera = preload("uid://dskry0mydaydk").instantiate()
	#character.add_child(camera)
	#character.add_to_group("player")
	#add_character(character, 1)
	#
	#$MovingDummy.team = 2
	
	#for i in enemies:
		#var enemy = load("res://characters/%s.tscn" %i).instantiate()
		#enemy.position = character.position + Vector2(randi_range(60,130), 0).rotated(randf_range(0, PI*2))
		#enemy.get_node("Controller").is_player = false
		#add_character(enemy, 2)
		
		#enemy.team = 2
		#add_child(enemy)

func add_character(character: Character, team: int):
	character.team = team
	add_child(character)
	UI.add_character_info(character)

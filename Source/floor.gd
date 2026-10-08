class_name Floor
extends Node3D

@export var environment: Node3D
@export var terrain: Terrain
@export var player_scene:PackedScene
@export var pickups: Node3D
@export var rocks: Node3D

var player:Player

func _ready() -> void:
	player = player_scene.instantiate()
	player.position = terrain.get_spot_on_terrain(0,0)
	add_child(player)
	spawn_rocks()

func spawn_rocks():
	for i in range(75):
		var rock = load("res://Source/Entities/Rocks/basic_rock.tscn").instantiate()
		rock.position = terrain.get_spot_on_terrain(
			randi_range(-terrain.size/2,terrain.size/2),
			randi_range(-terrain.size/2,terrain.size/2),
			)
		 
		rocks.add_child(rock)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_player() -> Player:
	return player

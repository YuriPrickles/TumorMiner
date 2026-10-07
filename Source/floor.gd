extends Node3D

@export var environment: Node3D
@export var terrain: Terrain
@export var player_scene:PackedScene

var player:Player

func _ready() -> void:
	player = player_scene.instantiate()
	player.position = Vector3(terrain.size/8,0,terrain.size/8)
	player.position.y = terrain.get_height(player.position.x, player.position.z) + 3
	add_child(player)

func spawn_rocks():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

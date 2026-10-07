class_name Pickup
extends RigidBody3D

@export var sprite: Sprite3D
var item_stored:Item

static func new_pickup(item:Item, pos:Vector3) -> void:
	var pickup:Pickup = preload("res://Source/pickup.tscn").instantiate()
	pickup.item_stored = item
	pickup.position = pos
	Main.instance.floor.pickups.add_child(pickup)

func _ready() -> void:
	sprite.texture = item_stored.texture

func on_body_entered(body:Node3D):
	if body is Player:
		Global.inv_manager.attempt_acquire(self,item_stored)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	sprite.rotate_y(deg_to_rad(1))
	pass

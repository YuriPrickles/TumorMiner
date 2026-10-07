class_name Entity
extends CharacterBody3D

@export var scene:PackedScene
	
@export var max_health:int = 1:
	set(value):
		max_health = value
		if health > max_health:
			health = max_health

var health:int:
	set(value):
		health = max(0, value)
func _ready() -> void:
	health = max_health

func hurt(hurt_amount:int):
	health -= hurt_amount
	if health <= 0:
		on_vanquish()
		queue_free()

func on_vanquish():
	pass

func _physics_process(_delta: float) -> void:
	pass

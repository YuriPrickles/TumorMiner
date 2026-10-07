class_name Entity
extends CharacterBody3D

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
		queue_free()

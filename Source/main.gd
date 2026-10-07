class_name Main
extends Node

@export var floor: Floor

static var instance: Main

func _ready() -> void:
	instance = self
	print(Utils.snakeificate("CopperPickaxe"))

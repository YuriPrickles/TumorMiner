extends Node

@export var inv_manager:InventoryManager
var current_item_index:int

@export_dir var items_texture_path: String

func _ready() -> void:
	inv_manager = InventoryManager.new()

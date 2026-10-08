class_name Item
extends Resource

enum Type {
	ITEM,
	PICKAXE,
	PART
}

@export var name : String = "Item"
@export var description : String = "Item"
@export var max_stack : int = 1
@export var texture : Texture2D

var stack: int = 1:
	set(value):
		if value > max_stack:
			stack = max_stack
			return
		stack = value

func _init(stk:int = 1) -> void:
	texture = load("%s/%s.png" % [
		Global.items_texture_path,
		get_item_class_name().to_snake_case()
		])
	stack = stk

func on_switch_to(plr:Player):
	pass

func on_switch_away(plr:Player):
	pass

func use_item(plr:Player):
	pass

func get_item_class_name() -> String:
	return(get_script() as Script).get_global_name()

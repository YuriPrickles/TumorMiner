class_name Rock
extends Item

func _init(stk:int=1) -> void:
	name = "Rock"
	description = "Rock. For building? Throwing?"
	max_stack = 5
	super(stk)

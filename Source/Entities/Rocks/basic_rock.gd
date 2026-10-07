class_name BasicRock
extends Entity


func on_vanquish():
	Pickup.new_pickup(Rock.new(3), position)

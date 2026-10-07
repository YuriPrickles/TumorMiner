class_name InventoryManager
extends Resource

@export var inventory:Array[Item]

func _init() -> void:
	inventory.resize(9)
	inventory[0] = Pickaxe.new()

func attempt_acquire(pickup:Pickup,item:Item):
	for i in range(inventory.size()):
		print(item.stack)
		if not inventory[i]:
			inventory[i] = item
			if item.stack > item.max_stack:
				inventory[i].stack = inventory[i].max_stack
				item.stack -= inventory[i].stack
				continue
			pickup.queue_free()
			break
		elif item.get_item_class_name() == inventory[i].get_item_class_name() and inventory[i].stack != inventory[i].max_stack:
			if inventory[i].stack + item.stack <= inventory[i].max_stack:
				inventory[i].stack += item.stack
				pickup.queue_free()
				break
			else:
				pickup.item_stored.stack = inventory[i].stack + item.stack - inventory[i].max_stack
				inventory[i].stack = inventory[i].max_stack
				break

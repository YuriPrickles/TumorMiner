extends Control

@export var health_label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var plr = Main.instance.floor.get_player()
	health_label.text = "[right][font_size=48]%s" % plr.health
	pass

tool
extends Area2D
export(Texture) var texture setget setTexture
export(int) var row setget setRow
export(int) var column setget setColumn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setTexture(newTexture):
	$Sprite.texture = newTexture
	texture = newTexture

func setRow(newRow):
	row = newRow
	
func setColumn(newColumn):
	column = newColumn

func _on_Area2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
			get_tree().call_group("TileGrid", "click_event", row, column, self)

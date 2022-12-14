tool
extends Area2D
export(Texture) var texture setget setTexture
export(String, "pink", "green", "orange", "teal") var colour setget setColour 
export(int) var row setget setRow
export(int) var column setget setColumn
onready var animationPlayer = get_node("AnimationPlayer")

var sprite_texture

func _ready():
	arrange_tile()
	$AnimationPlayer.play("Appear")

func arrange_tile():
	var row_position = 32 * row + 16
	var column_position = 32 * column + 16
	position = Vector2(column_position, row_position)

func setTexture(newTexture):
	$Sprite.texture = newTexture
	texture = newTexture

func setColour(newColour):
	colour = newColour
	$Background.texture = load("res://Textures/Backgrounds/" + colour + ".png")
	match colour:
		"pink":
			sprite_texture = load("res://Textures/Premium_Insects/Singles/47_Butterfly_Pink.png")
		"green":
			sprite_texture = load("res://Textures/Premium_Insects/Singles/39_Dragonfly.png")
		"orange":
			sprite_texture = load("res://Textures/Premium_Insects/Singles/22_Bee_Drone.png")
		"teal":
			sprite_texture = load("res://Textures/Premium_Insects/Singles/62_Scorpion_Blue.png")
	$Sprite.texture = sprite_texture

func setRow(newRow):
	row = newRow
	
func setColumn(newColumn):
	column = newColumn

func _on_Area2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().call_group("TileGrid", "click_event", row, column, self)

func animate_swap(animation):
	$AnimationPlayer.stop()
	$AnimationPlayer.play(animation)
	arrange_tile()

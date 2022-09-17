extends Node2D
var click_number

# Called when the node enters the scene tree for the first time.
func _ready():
	click_number = 1

func click_event(row, column):
	print("Tile at row: " + str(row) + ", column: " + str(column) + " has been clicked")
	print(click_number)
	if(click_number == 1):
		click_number = 2
	elif(click_number == 2):
		click_number = 1
	

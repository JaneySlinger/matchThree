extends Node2D
var click_number
var rows_clicked = {"first": null, "second": null}
var columns_clicked = {"first": null, "second": null}
var tiles_clicked = {"first": null, "second": null}

# Called when the node enters the scene tree for the first time.
func _ready():
	click_number = 1
	arrange_tiles()

func click_event(row, column, tile_ref):
	#print("Tile at row: " + str(row) + ", column: " + str(column) + " has been clicked")
	#print(click_number)
	if(click_number == 1):
		rows_clicked["first"] = row
		columns_clicked["first"] = column
		tiles_clicked["first"] = tile_ref
		click_number = 2
	elif(click_number == 2):
		rows_clicked["second"] = row
		columns_clicked["second"] = column
		tiles_clicked["second"] = tile_ref
		if(are_tiles_perpendicular()):
			swap_tiles()
		click_number = 1
	#print(rows_clicked)
	#print(columns_clicked)
	#print(are_tiles_perpendicular())


func are_tiles_perpendicular():
	return rows_clicked["first"] == rows_clicked["second"] or columns_clicked["first"] == columns_clicked["second"]

func swap_tiles():
	print("swapping tiles")
	var temp_tile_info = {"row": tiles_clicked["first"].row, "column": tiles_clicked["first"].column}
	tiles_clicked["first"].row = tiles_clicked["second"].row
	tiles_clicked["first"].column = tiles_clicked["second"].column
	
	tiles_clicked["second"].row = temp_tile_info["row"]
	tiles_clicked["second"].column = temp_tile_info["column"]
	
	rows_clicked = {"first": null, "second": null}
	columns_clicked = {"first": null, "second": null}
	tiles_clicked = {"first": null, "second": null}
	temp_tile_info = null
	arrange_tiles()
	

func arrange_tiles():
	for child in get_children():
		var row_position = 32 * child.row + 16
		var column_position = 32 * child.column + 16
		print(child)
		print(row_position)
		print(column_position)
		child.position = Vector2(column_position, row_position)
		print(child.position)
	

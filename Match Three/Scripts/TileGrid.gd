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

func are_tiles_perpendicular():
	return rows_clicked["first"] == rows_clicked["second"] or columns_clicked["first"] == columns_clicked["second"]

func swap_tiles():
	print("swapping tiles")
	var temp_tile_info = {"row": tiles_clicked["first"].row, "column": tiles_clicked["first"].column}
	tiles_clicked["first"].row = tiles_clicked["second"].row
	tiles_clicked["first"].column = tiles_clicked["second"].column
	
	tiles_clicked["second"].row = temp_tile_info["row"]
	tiles_clicked["second"].column = temp_tile_info["column"]
	
	arrange_tiles()
	is_match(tiles_clicked["first"])
	is_match(tiles_clicked["second"])
	
	rows_clicked = {"first": null, "second": null}
	columns_clicked = {"first": null, "second": null}
	tiles_clicked = {"first": null, "second": null}
	temp_tile_info = null
	
	

func arrange_tiles():
	for child in get_children():
		var row_position = 32 * child.row + 16
		var column_position = 32 * child.column + 16
		#print(child)
		#print(row_position)
		#print(column_position)
		child.position = Vector2(column_position, row_position)
		#print(child.position)
	

func is_match(tile):
	var texture_to_match = tile.texture

	var tile_to_left = get_tile_at_position(tile.row, tile.column - 1)
	var tile_to_right = get_tile_at_position(tile.row, tile.column + 1)
	if(do_textures_match(texture_to_match, tile_to_left, tile_to_right)):
		print("matched on both sides horizontally")
		remove_matched_tiles([tile, tile_to_left, tile_to_right])
		return true

	var tile_two_to_the_right = get_tile_at_position(tile.row, tile.column + 2)
	if(do_textures_match(texture_to_match, tile_to_right, tile_two_to_the_right)):
		print("matched two to the right")
		remove_matched_tiles([tile, tile_to_right, tile_two_to_the_right])
		return true
		
	#check two to the left
	var tile_two_to_the_left = get_tile_at_position(tile.row, tile.column - 2)
	if(do_textures_match(texture_to_match, tile_to_left, tile_two_to_the_left)):
		print("matched two to the left")
		remove_matched_tiles([tile, tile_to_left, tile_two_to_the_left])
		return true
		
	var tile_to_top = get_tile_at_position(tile.row - 1, tile.column)
	var tile_to_bottom = get_tile_at_position(tile.row + 1, tile.column)
	if(do_textures_match(texture_to_match, tile_to_top, tile_to_bottom)):
		print("matched both sides vertically")
		remove_matched_tiles([tile, tile_to_top, tile_to_bottom])
		return true
	#check two to the top
	var tile_two_to_top = get_tile_at_position(tile.row - 2, tile.column)
	if(do_textures_match(texture_to_match, tile_to_top, tile_two_to_top)):
		print("matched two to the top")
		remove_matched_tiles([tile, tile_to_top, tile_two_to_top])
		return true
		
	var tile_two_to_bottom = get_tile_at_position(tile.row + 2, tile.column)
	if(do_textures_match(texture_to_match, tile_to_bottom, tile_two_to_bottom)):
		print("matched two to the bottom")
		remove_matched_tiles([tile, tile_to_bottom, tile_two_to_bottom])
		return true

func get_tile_at_position(row, column):
	for child in get_children():
		if child.row == row and child.column == column:
			return child

func do_textures_match(texture, tile_1, tile_2):
	if(tile_1 != null and tile_2 != null):
		if(tile_1.texture == texture and tile_2.texture == texture):
			return true

func remove_matched_tiles(tiles):
	for tile in tiles:
		tile.queue_free()

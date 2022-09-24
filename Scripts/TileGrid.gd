tool
extends Node2D

export(int) var board_size setget set_board_size

var click_number
var rows_clicked = {"first": null, "second": null}
var columns_clicked = {"first": null, "second": null}
var tiles_clicked = {"first": null, "second": null}

var game_tile = preload("res://Scenes/GameTile.tscn")
var tiles = []
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	print("in ready")
	score = 0
	click_number = 1
	make_empty_board()
	generate_board()
	
func set_board_size(new_board_size):
	print("in set_board_size")
	board_size = new_board_size

func make_empty_board():
	for column in board_size:
		tiles.append([])
		for row in board_size:
			tiles[column].append(null) # Set a starter value for each position

func generate_board():
	var colours = ["pink", "green", "teal", "orange"]
	for column_index in board_size:
		for row_index in board_size:
			if(tiles[column_index][row_index] == null):
				randomize()
				var tile_instance = game_tile.instance()
				tile_instance.colour = colours[randi() % colours.size()]
				tile_instance.row = row_index
				tile_instance.column = column_index
				tiles[column_index][row_index] = tile_instance
				add_child(tile_instance)
	#arrange_tiles()

func click_event(row, column, tile_ref):
	match click_number:
		1:
			rows_clicked["first"] = row
			columns_clicked["first"] = column
			tiles_clicked["first"] = tile_ref
			click_number = 2
		2:
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
	call_swap_tiles_animation()
	tiles_clicked["first"].row = tiles_clicked["second"].row
	tiles_clicked["first"].column = tiles_clicked["second"].column
	
	tiles_clicked["second"].row = temp_tile_info["row"]
	tiles_clicked["second"].column = temp_tile_info["column"]
	
	
	#arrange_tiles()
	is_match(tiles_clicked["first"])
	is_match(tiles_clicked["second"])
	
	rows_clicked = {"first": null, "second": null}
	columns_clicked = {"first": null, "second": null}
	tiles_clicked = {"first": null, "second": null}
	temp_tile_info = null

func call_swap_tiles_animation():
	#first tile moving right, second tile left is column difference -1
	#first tile moving left, second moving right is column difference 1
	
	#first tile moving down, second up = row -1
	#first tile moving up, second down = row +1
	
	var row_difference = tiles_clicked["first"].row - tiles_clicked["second"].row
	var column_difference = tiles_clicked["first"].column - tiles_clicked["second"].column
	
	print("tile 1 column: " + str(tiles_clicked["first"].column), " tile 2 column: " + str(tiles_clicked["second"].column))
	print("column difference is: " + str(column_difference))
	
	match column_difference:
		1: 
			print("first tile going left")
			tiles_clicked["first"].animate_swap("Slide_left")
			tiles_clicked["second"].animate_swap("Slide_right")
		-1: 
			print("first tile going right")
			tiles_clicked["first"].animate_swap("Slide_right")
			tiles_clicked["second"].animate_swap("Slide_left")
	
	match row_difference:
		1:
			print("first tile going up")
			tiles_clicked["first"].animate_swap("Slide_up")
			tiles_clicked["second"].animate_swap("Slide_down")
		-1:
			print("first tile going down")
			tiles_clicked["first"].animate_swap("Slide_down")
			tiles_clicked["second"].animate_swap("Slide_up")
	
			
func arrange_tiles():
	print("arranging tiles")
	for child in get_children():
		var row_position = 32 * child.row + 16
		var column_position = 32 * child.column + 16
		child.position = Vector2(column_position, row_position)

func is_match(tile):
	var colour_to_match = tile.colour

	var tile_to_left = get_tile_at_position(tile.row, tile.column - 1)
	var tile_to_right = get_tile_at_position(tile.row, tile.column + 1)
	if(do_colours_match(colour_to_match, tile_to_left, tile_to_right)):
		print("matched on both sides horizontally")
		remove_matched_tiles([tile, tile_to_left, tile_to_right])
		return true

	var tile_two_to_the_right = get_tile_at_position(tile.row, tile.column + 2)
	if(do_colours_match(colour_to_match, tile_to_right, tile_two_to_the_right)):
		print("matched two to the right")
		remove_matched_tiles([tile, tile_to_right, tile_two_to_the_right])
		return true
		
	#check two to the left
	var tile_two_to_the_left = get_tile_at_position(tile.row, tile.column - 2)
	if(do_colours_match(colour_to_match, tile_to_left, tile_two_to_the_left)):
		print("matched two to the left")
		remove_matched_tiles([tile, tile_to_left, tile_two_to_the_left])
		return true
		
	var tile_to_top = get_tile_at_position(tile.row - 1, tile.column)
	var tile_to_bottom = get_tile_at_position(tile.row + 1, tile.column)
	if(do_colours_match(colour_to_match, tile_to_top, tile_to_bottom)):
		print("matched both sides vertically")
		remove_matched_tiles([tile, tile_to_top, tile_to_bottom])
		return true
	#check two to the top
	var tile_two_to_top = get_tile_at_position(tile.row - 2, tile.column)
	if(do_colours_match(colour_to_match, tile_to_top, tile_two_to_top)):
		print("matched two to the top")
		remove_matched_tiles([tile, tile_to_top, tile_two_to_top])
		return true
		
	var tile_two_to_bottom = get_tile_at_position(tile.row + 2, tile.column)
	if(do_colours_match(colour_to_match, tile_to_bottom, tile_two_to_bottom)):
		print("matched two to the bottom")
		remove_matched_tiles([tile, tile_to_bottom, tile_two_to_bottom])
		return true

func get_tile_at_position(row, column):
	for child in get_children():
		if child.row == row and child.column == column:
			return child

func do_colours_match(colour, tile_1, tile_2):
	if(tile_1 != null and tile_2 != null):
		if(tile_1.colour == colour and tile_2.colour == colour):
			return true

func remove_matched_tiles(tiles_to_remove):
	for tile in tiles_to_remove:
		score = score + 10
		print(score)
		tiles[tile.column][tile.row] = null
		tile.queue_free()
	generate_board()

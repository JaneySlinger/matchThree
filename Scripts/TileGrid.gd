tool
extends Node2D

export(int) var board_size setget set_board_size

var click_number
var tiles_clicked = {"first": null, "second": null}

var game_tile = preload("res://Scenes/GameTile.tscn")
var tiles = []
var score

func _ready():
	score = 0
	click_number = 1
	make_empty_board()
	generate_board()
	
func set_board_size(new_board_size):
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
				var looping = true
				while ( looping ):
					randomize()
					var tile_instance = game_tile.instance()
					tile_instance.colour = colours[randi() % colours.size()]
					tile_instance.row = row_index
					tile_instance.column = column_index
					tiles[column_index][row_index] = tile_instance
					if is_match(tile_instance) == null:
						add_child(tile_instance)
						looping = false
					else:
						tiles[column_index][row_index] = null

func click_event(row, column, tile_ref):
	match click_number:
		1:
			tiles_clicked["first"] = tile_ref
			click_number = 2
		2:
			tiles_clicked["second"] = tile_ref
			if(are_tiles_perpendicular()):
				swap_tiles()
			click_number = 1

func are_tiles_perpendicular():
	return tiles_clicked["first"].row == tiles_clicked["second"].row or tiles_clicked["first"].column == tiles_clicked["second"].column

func swap_tiles():
	var temp_tile_info = {"row": tiles_clicked["first"].row, "column": tiles_clicked["first"].column}
	call_swap_tiles_animation()
	tiles_clicked["first"].row = tiles_clicked["second"].row
	tiles_clicked["first"].column = tiles_clicked["second"].column
	tiles[tiles_clicked["first"].column][tiles_clicked["first"].row] = tiles_clicked["first"]
	
	tiles_clicked["second"].row = temp_tile_info["row"]
	tiles_clicked["second"].column = temp_tile_info["column"]
	tiles[tiles_clicked["second"].column][tiles_clicked["second"].row] = tiles_clicked["second"]
	
	var tiles_to_remove = is_match(tiles_clicked["first"])
	remove_matched_tiles(tiles_to_remove)
	tiles_to_remove = is_match(tiles_clicked["second"])
	remove_matched_tiles(tiles_to_remove)

	tiles_clicked = {"first": null, "second": null}
	temp_tile_info = null

func call_swap_tiles_animation():
	#first tile moving right, second tile left is column difference -1
	#first tile moving left, second moving right is column difference 1
	
	#first tile moving down, second up = row -1
	#first tile moving up, second down = row +1
	
	var row_difference = tiles_clicked["first"].row - tiles_clicked["second"].row
	var column_difference = tiles_clicked["first"].column - tiles_clicked["second"].column
	
	match column_difference:
		1: 
			tiles_clicked["first"].animate_swap("Slide_left")
			tiles_clicked["second"].animate_swap("Slide_right")
		-1: 
			tiles_clicked["first"].animate_swap("Slide_right")
			tiles_clicked["second"].animate_swap("Slide_left")
	
	match row_difference:
		1:
			tiles_clicked["first"].animate_swap("Slide_up")
			tiles_clicked["second"].animate_swap("Slide_down")
		-1:
			tiles_clicked["first"].animate_swap("Slide_down")
			tiles_clicked["second"].animate_swap("Slide_up")
			

func is_match(tile):
	var colour_to_match = tile.colour

	var tile_to_left = get_tile_at_position(tile.row, tile.column - 1)
	var tile_to_right = get_tile_at_position(tile.row, tile.column + 1)
	if(do_colours_match(colour_to_match, tile_to_left, tile_to_right)):
		print("matched on both sides horizontally")
		return [tile, tile_to_left, tile_to_right]

	var tile_two_to_the_right = get_tile_at_position(tile.row, tile.column + 2)
	if(do_colours_match(colour_to_match, tile_to_right, tile_two_to_the_right)):
		print("matched two to the right")
		return [tile, tile_to_right, tile_two_to_the_right]
		
	#check two to the left
	var tile_two_to_the_left = get_tile_at_position(tile.row, tile.column - 2)
	if(do_colours_match(colour_to_match, tile_to_left, tile_two_to_the_left)):
		print("matched two to the left")
		return [tile, tile_to_left, tile_two_to_the_left]
		
	var tile_to_top = get_tile_at_position(tile.row - 1, tile.column)
	var tile_to_bottom = get_tile_at_position(tile.row + 1, tile.column)
	if(do_colours_match(colour_to_match, tile_to_top, tile_to_bottom)):
		print("matched both sides vertically")
		return [tile, tile_to_top, tile_to_bottom]
		
	#check two to the top
	var tile_two_to_top = get_tile_at_position(tile.row - 2, tile.column)
	if(do_colours_match(colour_to_match, tile_to_top, tile_two_to_top)):
		print("matched two to the top")
		return [tile, tile_to_top, tile_two_to_top]
		
	var tile_two_to_bottom = get_tile_at_position(tile.row + 2, tile.column)
	if(do_colours_match(colour_to_match, tile_to_bottom, tile_two_to_bottom)):
		print("matched two to the bottom")
		return [tile, tile_to_bottom, tile_two_to_bottom]

func get_tile_at_position(row, column):
	if row in range(0,5) and column in range (0,5):
		return tiles[column][row]

func do_colours_match(colour, tile_1, tile_2):
	if(tile_1 != null and tile_2 != null):
		if(tile_1.colour == colour and tile_2.colour == colour):
			return true

func remove_matched_tiles(tiles_to_remove):
	if tiles_to_remove != null:
		for tile in tiles_to_remove:
			score = score + 10
			print(score)
			tiles[tile.column][tile.row] = null
			tile.queue_free()
		generate_board()

extends Node

signal on_player_move()
signal on_red_tile
signal on_green_tile

enum Tile {IS_WALL, IS_POTION, IS_EFFECT}

var game_objects: GameObjects = null

func tile_data(cell_position: Vector2i) -> Array:
	if game_objects == null:
		return []
		print("error: GameObjects Tileset layer does not exist")
	return game_objects.player_interaction(cell_position)
	

extends TileMapLayer
class_name GameObjects
enum Type {IS_WALL, IS_OBSTACLE, IS_POTION, IS_EFFECT, IS_MOVEABLE, IS_BUTTON}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_objects = self
	var tileset := get_tile_set()
	var atlas := tileset.get_source(3)
	for p in Potion.data:
		Potion.data[p]["potion_atlas_coords"] = find_tile(atlas, Type.IS_POTION, p)
		Potion.data[p]["effect_atlas_coords"] = find_tile(atlas, Type.IS_EFFECT, p)


func break_potion(cell: Vector2i, p: Potion.Type):
	set_cell(cell, 3, Potion.data[p]["effect_atlas_coords"])
	print(cell, Potion.data[p]["effect_atlas_coords"])

func collect_potion(cell: Vector2i):
	erase_cell(cell)
	
func find_tile(atlas: TileSetAtlasSource, is_object: int, potion_type: int) -> Vector2i:
	for i in atlas.get_tiles_count():
		var coords := atlas.get_tile_id(i)
		var data := atlas.get_tile_data(coords, 0)
		if data.get_custom_data("is_object") == is_object and data.get_custom_data("potion_type") == potion_type:
			return coords
	return Vector2i(-1, -1)
	

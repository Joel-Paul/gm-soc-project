extends TileMapLayer
class_name GameObjects
enum {IS_WALL, IS_OBSTACLE, IS_POTION, IS_EFFECT, IS_MOVEABLE}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_objects = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_interaction(player_pos: Vector2i)->Array:
	var cell_data := get_cell_tile_data(player_pos)
	
	if !cell_data:
		return []
	#print(cell_data.has_custom_data("is_object"))
	var return_array := [cell_data.get_custom_data("is_object"), null]
	if return_array[0] != IS_WALL:
		return_array[1] = cell_data.get_custom_data("potion_type")
		
	return return_array
		
	

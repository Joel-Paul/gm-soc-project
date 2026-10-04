extends Node
class_name GridMovement_C

@export var tween_anim := true
@export var effects_enabled := true
@export var can_jump := true
@export var object: Node2D

# logic variables
const MOVE_DIRECTIONS: Dictionary = {
	"up": Vector2i(0, -1),
	"down": Vector2i(0, 1),
	"left": Vector2i(-1, 0),
	"right": Vector2i(1, 0)
}

var step_len := 1
var cell_pos := Vector2i.ZERO
var push_strength := 1
@export var direction := MOVE_DIRECTIONS["right"]
@export var tween_time := 0.07

# anim variables
var tween: Tween


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_step_length(n: int):
	step_len = n

# returns its destiation
func move(dir: Vector2i, is_player: bool = false, speed := step_len) -> Vector2i:
	var dest: Vector2i
	for i in range(1, speed + 1):
		var path_pos := cell_pos + dir * i
		if _path_logic(path_pos, dir):
			dest = path_pos
		print(dest)
	
	cell_pos = _move_to(cell_pos, dest, !is_player);
	return cell_pos

# checks tile and returns true if traversable, false if not + some extra logic
# if hits a pushable object it basically uses recurssion (last object to be pushed
# in a chain of pushes gets resolved first)
func _path_logic(path_pos: Vector2i, dir: Vector2i) -> bool:
	var tile_data := Global.tile_data(path_pos)
	if !tile_data.is_empty():
		if tile_data[0] == GameObjects.IS_WALL or (!can_jump and tile_data[0] == GameObjects.IS_OBSTACLE): ###or !_check_projectile(dir, dest)*/)###:
			return false
		elif tile_data[0] == GameObjects.IS_POTION and object is not Player:
			#Global.game_objects
			pass
		elif tile_data[0] == GameObjects.IS_EFFECT and effects_enabled:
			Potion.data[tile_data[1]]["effect"].call(object)
	if path_pos in Global.game_entities.entity_dict:
		var entity = Global.game_entities.entity_dict[path_pos]
		entity.get_node_or_null("GridMovement_C").move(dir, push_strength)
			
	return true

#func _land_logic(path_pos: Vector2i) -> bool:
	#var tile_data := Global.tile_data(path_pos)
	#if !tile_data.is_empty():
		#if tile_data[0] == GameObjects.IS_WALL or (!can_jump and tile_data[0] == GameObjects.IS_OBSTACLE): ###or !_check_projectile(dir, dest)*/)###:
			#return false
		#elif tile_data[0] == GameObjects.IS_POTION and object is not Player:
			##Global.game_objects
			#pass
		#elif tile_data[0] == GameObjects.IS_EFFECT and effects_enabled:
			#Potion.data[tile_data[1]]["effect"].call(object)
		#return true

func _move_to(curr_cell: Vector2i, dest_cell: Vector2i, scale_time: bool = true) -> Vector2i:
	# Temporary message:
	# 	scale_time is an extra parameter to make the tween scale the time with the distance
	# 	if this is off, the tween time is always 0.07 seconds (ideal for the player, but not
	#	for the crates)
	
	var distance = (dest_cell - curr_cell).length();
	var tween_time_changed = tween_time;
	
	if (scale_time):
		tween_time_changed *= distance;
	
	var local_pos = Global.game_objects.map_to_local(dest_cell)
	if tween_anim:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(object, "position", local_pos, tween_time_changed);
	else:
		object.position = local_pos
	Global.game_entities.move_cell(curr_cell, dest_cell)
	return dest_cell
	
	

func teleport(coords: Vector2i):
	Global.game_entities.move_cell(cell_pos, coords)
	cell_pos = coords
	var local_pos = Global.game_objects.map_to_local(coords)
	object.position = local_pos

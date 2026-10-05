extends Node2D
class_name Player

signal player_move

const MOVE_DIRECTIONS: Dictionary = {
	"up": Vector2i(0, -1),
	"down": Vector2i(0, 1),
	"left": Vector2i(-1, 0),
	"right": Vector2i(1, 0)
}

#const MOVE_INTERVAL := 0.1
#var move_cooldown := 0.0
var has_superpower := false
var step_len := 1

@onready var movement := $GridMovement_C
@onready var inventory: Inventory = $Inventory

@onready var automove_timer: Timer = $AutoMove;
#@onready var move_buffer: Timer = $MoveBuffer;
var buffered_input: Vector2i = Vector2i.ZERO;

func _ready() -> void:
	movement.cell_pos = Global.game_objects.local_to_map(position)
	#super._ready()
	#button.pressed.connect(_on_pressed)
	#Global.on_red_tile.connect(_on_red_tile)
	#Global.on_green_tile.connect(_on_green_tile)

func _input(event: InputEvent) -> void:
	_receive_direction(event)
	_receive_throw(event)
	

func _physics_process(delta: float) -> void:
	if !movement.tween or !movement.tween.is_running():
		_receive_auto_direction()
		if (buffered_input):
			automove_timer.start();
			movement.move(buffered_input);
			if (abs(buffered_input.x) > 0):
				$"Sprite2D".flip_h = (buffered_input.x < 0);
				
				$"Sprite2D".scale.x = 2;
				$"Sprite2D".scale.y = 0.5;
			else:
				$"Sprite2D".scale.y = 2;
				$"Sprite2D".scale.x = 0.5;

			buffered_input = Vector2.ZERO

func _process(delta: float) -> void:
	#move_cooldown -= delta;
	
	$Sprite2D.scale = $Sprite2D.scale.lerp(Vector2(1,1), 0.26);
	
	#_receive_move_input();
	
	#print(move_cooldown);
	#if ((tween == null or !tween.is_running()) and move_cooldown < 0.0):
	#	_move(requested_move);
	
#func _on_pressed() -> void:
	#switch_animation()

# Checks if there is a projectile at the player destination and attempts to
# push it if there is.
#
# Return value: True if successful, False if not
#func _check_projectile(dir: Vector2i, dest: Vector2i) -> bool:
	#var projectile := get_projectile(dest)
	#if projectile:
		#var projectile_dest
		#if has_superpower:
			#projectile_dest = _find_superpower_dest(dest, dir);
		#else:
			#projectile_dest = dest + dir
		#if is_wall(projectile_dest) or get_projectile(projectile_dest):
			#return false;
		#projectile.move_to(projectile_dest)
#
	#return true;

func _receive_direction(event: InputEvent) -> void:
	for direction in MOVE_DIRECTIONS:
		if event.is_action_pressed(direction):
			buffered_input = MOVE_DIRECTIONS[direction];
			break;

func _receive_auto_direction() -> void:
	for direction in MOVE_DIRECTIONS:
		if Input.is_action_pressed(direction) and automove_timer.is_stopped():
			buffered_input = MOVE_DIRECTIONS[direction];
			break;

func _receive_throw(event: InputEvent) -> void:
	if event.is_action_pressed("throw"):
		inventory.throw()

#func _on_red_tile() -> void:
	#step_len = 2
	#
#func _on_green_tile() -> void:
	#has_superpower = true
	
func get_player_position() -> Vector2:
	return position
	
#func _find_superpower_dest(cell_pos: Vector2i, dir: Vector2i) -> Vector2i:
	#var dest := cell_pos + dir
	#while not is_wall(dest) and not get_projectile(dest):
		#dest += dir
	#dest -= dir
	#return dest

func _on_move_buffer_timeout() -> void:
	buffered_input = Vector2i.ZERO;

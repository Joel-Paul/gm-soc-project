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

# Timer that handles held movement inputs
@onready var automove_timer: Timer = $AutoMove;

# Timer that clears buffered inputs after 0.1 seconds of inactivity
@onready var buffer_timer: Timer = $BufferClear;
var buffered_input: Array[Vector2i] = [];

func _ready() -> void:
	movement.cell_pos = Global.game_objects.local_to_map(position)

func _input(event: InputEvent) -> void:
	_receive_direction(event)
	_receive_throw(event)
	

func _physics_process(delta: float) -> void:
	if !movement.tween or !movement.tween.is_running():
		if (len(buffered_input) > 0):
			automove_timer.start();
			
			var input: Vector2i = buffered_input[0];
			
			movement.move(input);
			if (abs(input.x) > 0):
				$"Sprite2D".flip_h = (input.x < 0);
				
				$"Sprite2D".scale.x = 1.2;
				$"Sprite2D".scale.y = 0.8;
			else:
				$"Sprite2D".scale.y = 1.2;
				$"Sprite2D".scale.x = 0.8;

			buffered_input.pop_front();
		
		_receive_auto_direction()

func _process(delta: float) -> void:
	#move_cooldown -= delta;
	
	$Sprite2D.scale = $Sprite2D.scale.lerp(Vector2(1,1), 0.26);


func _receive_direction(event: InputEvent) -> void:
	for direction in MOVE_DIRECTIONS:
		if event.is_action_pressed(direction):
			buffered_input.append(MOVE_DIRECTIONS[direction]);
			
			buffer_timer.start();

func _receive_auto_direction() -> void:
	for direction in MOVE_DIRECTIONS:
		if Input.is_action_pressed(direction) and automove_timer.is_stopped():
			buffered_input.append(MOVE_DIRECTIONS[direction]);
			
			buffer_timer.start();

func _receive_throw(event: InputEvent) -> void:
	if event.is_action_pressed("throw"):
		inventory.throw()
	
func get_player_position() -> Vector2:
	return position
	
func _on_buffer_clear_timeout() -> void:
	buffered_input.clear();

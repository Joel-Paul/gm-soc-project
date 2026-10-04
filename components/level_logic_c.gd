extends TileMapLayer
class_name  GameEntities

var game_entities: Dictionary[Vector2i, Node] = {}
@export var player_pos: Vector2i
@export var player: Player
# Called when the node enters the scene tree for the first time.
# game_entities.gd
func _enter_tree() -> void:
	Global.game_entities = self

func _exit_tree() -> void:
	if Global.game_entities == self:
		Global.game_entities = null

func _ready() -> void:
	game_entities[player_pos] = player
	
	for coord in game_entities:
		var movement := game_entities[coord].get_node_or_null("GridMovement_C")
		if movement:
			movement.teleport(coord)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

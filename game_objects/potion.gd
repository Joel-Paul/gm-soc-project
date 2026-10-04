extends Node
class_name Potion

enum Type {SPEED_UP, SLOW_DOWN, STRENGTH}

var data = {
	Type.SPEED_UP: {
		"effect": null
	},
	
	Type.SLOW_DOWN: {
		"effect": null
	},
	
	Type.STRENGTH: {
		"effect": null
	},
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

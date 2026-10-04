extends Node2D
class_name Inventory

var slots_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_potion(potion: Potion):
	if slots_array.size() < 3:
		slots_array.append(potion)
		return true
	else:
		return false

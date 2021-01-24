extends Control

onready var cursor = $Cursor
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		cursor.position = get_global_mouse_position()
		for body in cursor.get_overlapping_bodies():
			if body.has_method("get_info"):
				print(body.call("get_info"))
		

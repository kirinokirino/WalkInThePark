extends Control

onready var cursor = $Cursor
onready var UI = $PasserbyInfo
onready var UIlabel = $PasserbyInfo/Text
const UIoffset: Vector2 = Vector2(-100, -150)

var followed_passerby = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		cursor.position = get_global_mouse_position()
		for body in cursor.get_overlapping_bodies():
			if body!= followed_passerby and body.has_method("get_info"):
				followed_passerby = body
				var info = body.call("get_info")
				UI.rect_position = body.position + UIoffset
				UI.visible = true
				UIlabel.text = info
				
func _process(delta):
	if (followed_passerby && is_instance_valid(followed_passerby)):
		UI.rect_position = followed_passerby.position + UIoffset
	else:
		UI.visible = false
		

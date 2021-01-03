extends Node2D

enum PathNodeType { Exit, Target, PathNode }

export (PathNodeType) var type
var connections: Array;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func add_connection(to: Node2D):
	connections.push_front(to)

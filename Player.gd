extends KinematicBody2D

var velocity := Vector2()
export(float) var speed := 200

func _ready() -> void:
	pass

func _process(delta):
	
	var modifier = 1
	if Input.is_action_pressed("speed"):
		modifier = 2
	
	velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	velocity.y = Input.get_action_strength("down") - Input.get_action_strength("up") 
	velocity *= speed * modifier * delta
	
	position += velocity

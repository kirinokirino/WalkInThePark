extends Node2D
onready var this = $"."
onready var focusPoint = $Focus
onready var focusLine: Line2D = $FocusLine
const unfocusedPosition := Vector2(100,0)

onready var vision: Area2D = $Vision

onready var park = get_parent().get_parent()
onready var origin: Node;
onready var target_exit: Node;

onready var target: Vector2 = origin.position
var velocity := Vector2()
var is_slowing_down := false
var path: Array;
export(float) var speed := 200

export(float) var slowdown_duration := 2.0
var timer: float = 0.0

const wait_time := 1
var is_waiting := true

func _ready() -> void:
	pass

func init(_origin: Node, _target_exit: Node) -> void:
	origin = _origin
	target_exit = _target_exit

func _physics_process(delta):
	
	focusCheck()
	
	if (is_slowing_down):
		turning(delta)
		return
			
	elif (is_waiting):
		wait(delta)
		return
		
	else:
		walking(delta)
		return
			
func turning(delta):
	timer += delta
	var target_velocity = (target-position).normalized() * speed
	
	var current_vel = lerp(velocity, target_velocity, (timer/slowdown_duration))
	rotation = current_vel.angle()
	position += current_vel*delta
	if (timer > slowdown_duration):
		is_slowing_down = false
	
func wait(delta):
	timer += delta
	if timer > wait_time:
		target = get_target()
		is_waiting = false
	
func walking(delta):
	
	velocity = (target-position).normalized() * speed
	rotation = velocity.angle()
	position += velocity*delta
	if (target_exit.position == target):
		if ((target - position).length() < 7):
			queue_free()
	elif ((target - position).length() < 50):
		target = get_target()
		timer = 0
		is_slowing_down = true

func get_target() -> Vector2:
	if (path):
		var next_node = path.pop_front()
		return next_node.position
	else:
		path = park.call("give_path", position, target_exit)
		
#		var line = Line2D.new()
#		for p in path:
#			line.add_point(p.position)
#		get_parent().add_child(line)
		var next_node = path.pop_front()
		return next_node.position

func focusCheck() -> void:
	var inVisionEntities = vision.get_overlapping_bodies()
	if (inVisionEntities.size() > 1):
		inVisionEntities.erase(this)
		inVisionEntities.shuffle()
		changeFocus(inVisionEntities[0])
	else:
		unfocus()

func updateFocusLine() -> void:
	focusLine.remove_point(1)
	focusLine.add_point(focusPoint.position)

func unfocus() -> void:
	focusPoint.position = unfocusedPosition
	updateFocusLine()

func changeFocus(to: Node) -> void:
	if(to.get_name() == "Place"):
		focusPoint.position = (to.position + to.get_parent().position - position).rotated(-rotation)
	else:
		focusPoint.position = (to.position - position).rotated(-rotation)
	
	updateFocusLine()

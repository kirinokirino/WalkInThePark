extends KinematicBody2D

# Components of the entity
onready var this = $"."
onready var focusPoint = $Focus
onready var focusLine: Line2D = $FocusLine
onready var focusCone: Polygon2D = $FocusCone
const unfocusedPosition := Vector2(100,0)
onready var vision: Area2D = $Vision
onready var bench_wait: Timer = $BenchWait

# Path variables
var wants_to_rest_on_a_bench: bool;
onready var park = get_parent().get_parent()
onready var origin: Node;
onready var target_exit: Node;
onready var target: Vector2 = origin.position
var path: Array;

# Movement variables
export(float) var speed := 200
var velocity := Vector2()
var is_slowing_down := false
export(float) var slowdown_duration := 2.0
var wait_time := 1
var is_waiting := true

# Focus variables
export(float) var focus_duration := 1
var timer: float = 0.0
var focus_timer: float = 0.0
var focusedOnEntity: Node = null
var focus_immunity_list: Array
export(int) var focus_immunity_list_size: int = 3

var description: Array

func _ready() -> void:
	if (randf() < 0.25):
		wants_to_rest_on_a_bench = true
	pass

func init(_origin: Node, _target_exit: Node, _description: Array) -> void:
	origin = _origin
	target_exit = _target_exit
	description = _description

func _physics_process(delta):
	focusCheck(delta)
	
	if (is_slowing_down):
		position += turning(delta) * delta
		return
	elif (is_waiting):
		wait(delta)
		return
	else:
		position += walking(delta) * delta
		
func get_info():
	return (description[1] + ", " + description[2])
	
# Movement ----------------------------------------------------
		
func turning(delta) -> Vector2:
	timer += delta
	var target_velocity = (target-position).normalized() * speed
	
	var current_vel = lerp(velocity, target_velocity, (timer/slowdown_duration))
	rotation = current_vel.angle()
	if (timer > slowdown_duration):
		is_slowing_down = false
		
	return current_vel
	
func wait(delta):
	timer += delta
	if timer > wait_time:
		target = get_target()
		is_waiting = false
		timer = 0

func walking(_delta) -> Vector2:
	velocity = (target-position).normalized() * speed
	rotation = velocity.angle()
	if (target_exit.position == target):
		if ((target - position).length() < 7):
			queue_free()
	elif ((target - position).length() < 50):
		target = get_target()
		timer = 0
		is_slowing_down = true
	return velocity
	
func get_target() -> Vector2:
	if (path):
		var to = path.pop_front()
		if (path.size() == 1 and wants_to_rest_on_a_bench):
			if (park.call("is_bench_occupied", to)):
				wants_to_rest_on_a_bench = false
				path.pop_back()
				
		if (!path and wants_to_rest_on_a_bench):
			wants_to_rest_on_a_bench = false
			
			if (!park.call("is_bench_occupied", to)):
				park.call("occupy_bench", position)
				bench_wait.start()
				wait_time = 1000
				path.append(to.position + to.get_child(1).position.rotated(to.rotation)*1.5)
				
		if(typeof(to) == TYPE_OBJECT):
			return to.position
		else:
			return to
	else:
		if (!bench_wait.paused):
			is_waiting = true
			path = park.call("give_path", position, target_exit)
		if (wants_to_rest_on_a_bench):
			path = park.call("give_path_to_bench", position)
		else:
			path = park.call("give_path", position, target_exit)
		
		var next_node = path.pop_front()
		return next_node.position

# Focus --------------------------------------------
		
func focusCheck(delta) -> void:
	
	focus_timer += delta
	
	var inVisionEntities = vision.get_overlapping_bodies()
		
	if (inVisionEntities.size() > 1):
		inVisionEntities.erase(this)
	else:
		focusedOnEntity = null
		unfocus()
		return
			
	if (focus_timer > focus_duration):
		focus_timer = 0
		if (randf() < 0.5):
			focusedOnEntity = null
			unfocus()
			return
		else:
			for immune in focus_immunity_list:
				inVisionEntities.erase(immune)
			if inVisionEntities.size() <= 0:
				focusedOnEntity = null
				unfocus()
				return
				
			inVisionEntities.shuffle()
			focusedOnEntity = inVisionEntities[0]
			focus_immunity_list.append(focusedOnEntity)
			if focus_immunity_list.size() > focus_immunity_list_size:
				focus_immunity_list.pop_front()
		
	changeFocus(focusedOnEntity)

func updateFocusLine() -> void:
	focusLine.remove_point(1)
	focusLine.add_point(focusPoint.position)
	var points = focusLine.points

	var vec: Vector2 = (points[1] - points[0])
	var angle := vec.angle()
	focusCone.set_polygon(PoolVector2Array([points[0], 
	(points[1] + Vector2(0, -22).rotated(angle)),
	(points[1] + Vector2(7, -20.25).rotated(angle)), 
	(points[1] + Vector2(15, -15.7).rotated(angle)), 
	(points[1] + Vector2(21.4, -8.77).rotated(angle)), 
	(points[1] + Vector2(23.4, 0).rotated(angle)), 
	(points[1] + Vector2(21.4, 8.77).rotated(angle)), 
	(points[1] + Vector2(15, 15.7).rotated(angle)), 
	(points[1] + Vector2(7, 20.25).rotated(angle)), 
	(points[1] + Vector2(0, 22).rotated(angle))]))
	
func unfocus() -> void:
	focusPoint.position = unfocusedPosition
	updateFocusLine()

func changeFocus(to: Node) -> void:
	if(!is_instance_valid(to)):
		unfocus()
	elif(to.get_name() == "Place"):
		focusPoint.position = (-to.position.rotated(to.get_parent().rotation_degrees) + to.get_parent().position - position).rotated(-rotation)
	else:
		focusPoint.position = (to.position - position).rotated(-rotation)
	
	updateFocusLine()

func _on_BenchWait_timeout():
	park.call("free_bench", position)
	is_waiting = false
	

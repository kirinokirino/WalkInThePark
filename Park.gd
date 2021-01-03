extends Node2D

var passerby = preload("res://Passerby.tscn")

onready var objects := $Objects
onready var connections := $Navigation/Connections
var exits: Array;
var targets: Array;
var roads: Array;
var navigation: Array;
var visited: Array;

func _input(event) -> void:
	if event.is_action_pressed("click"):
		test_passerby(get_global_mouse_position())
		
func _ready() -> void:
	randomize()
	exits = get_exits()
	targets = get_targets()
	roads = get_roads()
	navigation = exits + targets + roads
	make_connections()
	for _i in range(0):
		create_passerby()
		

func create_passerby():
	exits.shuffle()
	var p = passerby.instance()
	p.translate(exits[0].position)
	p.call_deferred("init", exits[0], exits[1])
	objects.call_deferred("add_child", p)

func test_passerby(pos: Vector2):
	exits.shuffle()
	var p = passerby.instance()
	p.translate(pos)
	p.call_deferred("init", exits[0], exits[1])
	objects.call_deferred("add_child", p)

func make_connections() -> void:
	var exit1 = exits[0]
	var exit2 = exits[1]
	var exit3 = exits[2]
	var exit4 = exits[3]
	var exit5 = exits[4]
	var exit6 = exits[5]
	var exit7 = exits[6]
	var exit8 = exits[7]
	var exit9 = exits[8]
	
	var road1 = roads[0]
	var road2 = roads[1]
	var road3 = roads[2]
	var road4 = roads[3]
	var road5 = roads[4]
	var road6 = roads[5]
	var road7 = roads[6]
	var road8 = roads[7]
	var road9 = roads[8]
	var road10 = roads[9]
	var road11 = roads[10]
	var road12 = roads[11]
	var road13 = roads[12]
	var road14 = roads[13]
	var road15 = roads[14]
	var road16 = roads[15]
	var road17 = roads[16]
	var road18 = roads[17]
	var road19 = roads[18]
	var road20 = roads[19]
	var road21 = roads[20]
	var road22 = roads[21]
	var road23 = roads[22]
	
	var bench1 = targets[0]
	var bench2 = targets[1]
	
	create_connection(road4, bench1)
	create_connection(road5, bench1)
	create_connection(road16, bench2)
	
	create_connection(exit2, road1)
	create_connection(road1, road2)
	create_connection(road2, road3)
	create_connection(road3, road4)
	create_connection(road4, road5)
	create_connection(road5, road6)
	create_connection(road5, exit1)
	create_connection(road6, road7)
	create_connection(road6, exit9)
	create_connection(road7, road8)
	create_connection(road7, exit8)
	create_connection(road9, road3)
	create_connection(road9, road4)
	create_connection(road9, road8)
	create_connection(road8, road10)
	create_connection(road10, road11)
	create_connection(road11, road12)
	create_connection(road12, road13)
	create_connection(road13, road14)
	create_connection(road14, road1)
	create_connection(road12, road15)
	create_connection(road15, road16)
	create_connection(exit3, road16)
	create_connection(exit4, road16)
	create_connection(road16, road17)
	create_connection(road17, road18)
	create_connection(road18, road19)
	create_connection(road19, road20)
	create_connection(road20, exit5)
	create_connection(road19, road21)
	create_connection(exit6, road21)
	create_connection(exit7, road21)
	create_connection(road19, road22)
	create_connection(road22, road23)
	create_connection(road23, road7)
	
func create_connection(first: Node2D, second: Node2D) -> void:
#	var line = Line2D.new()
#	line.add_point(first.position)
#	line.add_point(second.position)
#	connections.call_deferred("add_child", line)
	first.propagate_call("add_connection", [second])
	second.propagate_call("add_connection", [first])
	
func give_path(from: Vector2, destination: Node) -> Array:
	var current = get_closest_navigation(from)	
	
	visited = []
	var path = search_path(current, destination)
	return path
	
func search_path(current: Node, target: Node) -> Array:
	var stack: Array = [current]
	while(stack.size() > 0):
		var connection = stack.back()
		if connection == target:
			stack.push_back(connection)
			return stack
			
		var processed := true
		var neighbors : Array = connection.get_child(0).connections
		neighbors.shuffle()
		for neigbor in neighbors:
			if (!visited.has(neigbor) and !stack.has(neigbor)):
				stack.push_back(neigbor)
				processed = false
				break
		if (processed):
			stack.pop_back()
			visited.append(connection)
			
		assert(stack.size() < 100)
	print_debug("This shouldn't happen.")
	return [Vector2(-100,-100)]	
	
	
func get_closest_navigation(from: Vector2) -> Node:
	var result_navigation: Node;
	var distance: float = 9999999;
	
	for path_point in navigation:
		var new_distance = (path_point.position - from).length()
		if (distance > new_distance):
			result_navigation = path_point
			distance = new_distance
			
	return result_navigation
	
func get_exits() -> Array:
	return get_node("Navigation/Exits").get_children()
	
func get_targets() -> Array:
	return get_node("Navigation/Targets").get_children()

func get_roads() -> Array:
	return get_node("Navigation/Roads").get_children()
	

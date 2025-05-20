extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var p_s = get_node("/root/main/main/playerShip")

# Called when the node enters the scene tree for the first time.

func _process(_delta):
	set_compass(p_s.global_rotation.y)
#	print ("global roation: ", p_s.global_rotation.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
enum {north, north_east, east, south_east, south, south_west, west, north_west}
var current_direction = 52 

const north_north_east = -3.0/5.0 * PI
const east_north_east = -4.0/5.0 * PI
const east_south_east = 4.0/5.0 * PI
const south_south_east = 3.0/5.0 * PI
const south_south_west = 2.0/5.0 * PI
const west_south_west = 1.0/5.0 * PI
const west_north_west = -1.0/5.0 * PI
const north_north_west = -2.0/5.0 * PI
const pos_true_east = PI
const neg_true_east = -PI 

func set_compass(direction_rad):
	if direction_rad < north_north_west && direction_rad > north_north_east:
		if change_direction(north):
			 $ship/n.visible = true
	elif direction_rad < north_north_east && direction_rad > east_north_east:
		if change_direction(north_east):
			$ship/ne.visible = true
	elif (direction_rad < east_north_east && direction_rad >= neg_true_east) || (direction_rad < pos_true_east && direction_rad > east_south_east):
		if change_direction(east):
			$ship/e.visible = true
	elif direction_rad < east_south_east && direction_rad > south_south_east:
		if change_direction(south_east):
			$ship/se.visible = true
	elif direction_rad < south_south_east && direction_rad > south_south_west:
		if change_direction(south):
			$ship/s.visible = true
	elif direction_rad < south_south_west && direction_rad > west_south_west:
		if change_direction(south_west):
			$ship/sw.visible = true
	elif ( direction_rad < west_south_west && direction_rad >= 0 ) || ( direction_rad > west_north_west && direction_rad <= 0 ):
		if change_direction(west):
			$ship/w.visible = true
	elif direction_rad < west_north_west && direction_rad > north_north_west:
		if change_direction(north_west):
			$ship/nw.visible = true 

func change_direction(new_direction):
	if current_direction != new_direction:
		current_direction = new_direction
		hide_ships()
		return true
	else:
		return false

func hide_ships():
	$ship/n.visible = false
	$ship/ne.visible = false
	$ship/e.visible = false
	$ship/se.visible = false
	$ship/s.visible = false
	$ship/sw.visible = false
	$ship/w.visible = false
	$ship/nw.visible = false

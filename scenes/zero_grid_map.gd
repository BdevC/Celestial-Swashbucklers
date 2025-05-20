extends GridMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("obstacles")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_player_contact(player_basis):
	var ship_pos:Vector3 = world_to_map(player_basis)
	set_cell_item(ship_pos.x, ship_pos.y, ship_pos.z, INVALID_CELL_ITEM)
	
	set_cell_item(ship_pos.x-1.0, ship_pos.y, ship_pos.z, INVALID_CELL_ITEM)
	set_cell_item(ship_pos.x+1.0, ship_pos.y, ship_pos.z, INVALID_CELL_ITEM)
	
	set_cell_item(ship_pos.x, ship_pos.y, ship_pos.z-1.0, INVALID_CELL_ITEM)
	set_cell_item(ship_pos.x, ship_pos.y, ship_pos.z+1.0, INVALID_CELL_ITEM)
	
	set_cell_item(ship_pos.x-1.0, ship_pos.y, ship_pos.z-1.0, INVALID_CELL_ITEM)
	set_cell_item(ship_pos.x-1.0, ship_pos.y, ship_pos.z+1.0, INVALID_CELL_ITEM)
	set_cell_item(ship_pos.x+1.0, ship_pos.y, ship_pos.z-1.0, INVALID_CELL_ITEM)
	set_cell_item(ship_pos.x+1.0, ship_pos.y, ship_pos.z+1.0, INVALID_CELL_ITEM)
	

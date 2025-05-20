extends Area

const collidable_groups = ["Player"]	#maybe some future enemy will steal coins from the map

signal bonus_area()

const SCORE_ADDITION = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",self,"_on_something_hit")
	connect("bonus_area",get_node("/root/main/main"), "_handle_bonus_area")

func _process(delta):
	rotate_y(delta)

func _on_something_hit(body):
	for group in collidable_groups:
		if body.is_in_group(group):
			emit_signal("bonus_area")
			queue_free()

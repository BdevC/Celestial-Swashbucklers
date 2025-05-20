extends RigidBody

var playerCollisions:int = 0
export var max_player_collisions:int = 0

func impact():
	pass		# Do something when the ship hits the object


func _on_formationLarge_rock_body_entered(body):
	if (body.is_in_group("Player")):
		playerCollisions +=1
		print("pillar:", get_instance_id(), " hit player")
	if (playerCollisions > max_player_collisions):
		queue_free()

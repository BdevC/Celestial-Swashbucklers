extends RigidBody

export var attack_speed:float = 1500
var crash_rotation:float = 0.02
var is_crashing:bool = false
var descent_speed:float = 0.0
var deathTimer:Timer

var forward_direction# = global_transform.basis.z.normalized()

#func _ready():
	

func crash():
	is_crashing = true
#	$AttackCraft.set_linear_velocity(Vector3(0,-100,0))

func _ready():
	forward_direction = global_transform.basis.z.normalized()
	add_central_force(forward_direction * attack_speed)

func _physics_process(delta):
	pass

#func _process(delta):
#	if (is_crashing):
#		$AttackCraft.rotate_z(crash_rotation)
#		$AttackCraft.move_and_slide(Vector3(0,descent_speed,0), Vector3.UP)
#		descent_speed -=0.8
	
#	#make this better
#	if ($AttackCraft.get_translation().y <= -100 ): #todo change -100 to a colision
#		print("bye bye")
#		self.queue_free()





func _on_AttackCraft_body_entered(body):
	axis_lock_linear_y = false
	$DeathTimer.start()


func _on_DeathTimer_timeout():
	queue_free()

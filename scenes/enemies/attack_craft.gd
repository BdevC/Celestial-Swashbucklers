extends RigidBody

export var attack_speed:float = 5
export var max_speed:int = 25
var crash_rotation:float = 0.02
var is_crashing:bool = false
var descent_speed:float = 0.0
var deathTimer:Timer
var is_under_speed:bool = true
var target
var old_position:Vector3
var old_idx:int = 0


var forward_direction:Vector3# = global_transform.basis.z.normalized()

signal hitPlayer(id)
signal shot_down_by_player(id)
#func _ready():
	

func crash():
	is_crashing = true
#	$AttackCraft.set_linear_velocity(Vector3(0,-100,0))

func _ready():
#	add_central_force(forward_direction * attack_speed)
	self.connect("hitPlayer",get_node("/root/main/main"),"_on_RamShip_Collide")
	self.connect("shot_down_by_player",get_node("/root/main/main"),"_on_ramship_shot_down")
	add_to_group("attackCraft")
	old_position = global_transform.origin
#	forward_direction = target.global_transform.origin - global_transform.origin
#	add_central_force(forward_direction.normalized() * 100000)

func pursue(force):
	forward_direction = target.global_transform.origin - global_transform.origin
	add_central_force(forward_direction.normalized() * force)

func _physics_process(_delta):
	if !is_crashing && is_under_speed :
		pursue(attack_speed)
#	if old_idx > 30:
#		print("updating old_position")
#		old_idx = 0
#		old_position = get_global_transform().origin
#	old_idx += 1

#func look_follow(state, current_transform, target_position):
#	var up_dir = Vector3(0, 1, 0)
#	var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
#	var target_dir = (current_transform.origin - target_position).normalized()
#	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
#
#	state.set_angular_velocity(up_dir * (rotation_angle / state.get_step()))

func integrate_forces(state):
	is_under_speed = linear_velocity.x < max_speed && linear_velocity.y < max_speed && linear_velocity.z < max_speed
#	look_follow(state, get_global_transform(), old_position)
#func _process(delta):
#	if (is_crashing):
#		$AttackCraft.rotate_z(crash_rotation)
#		$AttackCraft.move_and_slide(Vector3(0,descent_speed,0), Vector3.UP)
#		descent_speed -=0.8
	
#	#make this better
#	if ($AttackCraft.get_translation().y <= -100 ): #todo change -100 to a colision
#		print("bye bye")
#		self.queue_free()

var health_kit = preload("res://scenes/items/HealthKit.tscn")
var ammo_kit = preload("res://scenes/items/AmmoPickup.tscn")



func _on_AttackCraft_body_entered(body):
	axis_lock_linear_y = false
	$DeathTimer.start()
	if body.is_in_group("Player"):	# the player was hit by the craft
		is_crashing = true
		emit_signal("hitPlayer", get_instance_id())
	if body.is_in_group("playerAmmo") && is_crashing == false:	# the player shot down the craft
		is_crashing = true
		emit_signal("shot_down_by_player", get_instance_id())
		var scene_root = get_node("/root/main/main")
		var new_health = health_kit.instance()
		new_health.global_transform = global_transform
		var new_ammo = ammo_kit.instance()
		new_ammo.global_transform = global_transform
		scene_root.add_child(new_health)
		scene_root.add_child(new_ammo) 

func _on_DeathTimer_timeout():
	queue_free()

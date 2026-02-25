extends CharacterBody3D
var active : bool = false
var thrust_speed : float = 45.0
var thrust_timer : float = 0.0
var thrust_time : float = 0.1

var dash_speed : float = 45.0
var dash_time : float = 0.15
var dash_timer : float = 0.0
var is_dashing : bool = false
var dash_direction : Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	
	$"../UI/Attack".max_value = .2
	$"../UI/Attack".value = .2-$Cooldown.time_left

	$"../UI/Special".max_value = 3
	$"../UI/Special".value = 3-$Special.time_left

	rotate_x(basis.z.signed_angle_to(-$"../PlayerCamera".basis.z, Vector3.RIGHT))
	
	if Input.is_action_just_pressed("attack") && $Cooldown.is_stopped(): 
		$Cooldown.start() 
		active = true
		thrust_timer = 0.0
		var list = $Hitbox.get_overlapping_bodies()
		for i in list:
			_on_hitbox_body_entered(i)
	if(active == true):
		thrust(delta)
	if Input.is_action_just_pressed("special") && $Special.is_stopped(): 
		start_dash()
	if(is_dashing):
		handle_dash(delta)
	
	move_and_slide()
func thrust(delta: float):
	thrust_timer += delta
	var forward := global_transform.basis.z
	if thrust_timer < thrust_time :
		velocity = forward * thrust_speed
	else:
		position = Vector3.ZERO
		velocity = Vector3.ZERO
		active = false


func _on_hitbox_body_entered(body: Node3D) -> void:
	if(body.has_method("take_damage") && active == true):
		body.take_damage(15)
	
	if(body.has_method("take_damage") && is_dashing == true):
		body.take_damage(15)
	
func start_dash():
	is_dashing = true
	$"..".invincible = true
	dash_timer = 0.0
	dash_direction = global_transform.basis.z.normalized()
	$Special.start()
	
func handle_dash(delta: float):
	dash_timer += delta
	
	if dash_timer < dash_time:
		$"..".knockbackVelocity = dash_direction * dash_speed
		$"..".knockbackVelocity.y = 0  
	else:
		is_dashing = false
		$"..".invincible = false

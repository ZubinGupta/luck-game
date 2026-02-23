extends CharacterBody3D
var active : bool = false
var thrust_speed : float = 30.0
var thrust_timer : float = 0.0
var thrust_time : float = 0.1


func _physics_process(delta: float) -> void:
	rotate_x(basis.z.signed_angle_to(-$"../PlayerCamera".basis.z, Vector3.RIGHT))
	
	if Input.is_action_just_pressed("attack") && $Cooldown.is_stopped(): 
		$Cooldown.start() 
		active = true
		thrust_timer = 0.0
	if(active == true):
		thrust(delta)
	
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
		body.take_damage(20)
	

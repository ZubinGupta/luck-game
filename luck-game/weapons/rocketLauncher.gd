extends CharacterBody3D

var attack: PackedScene = preload("res://weapons/rocketAttack.tscn")

func _physics_process(delta: float) -> void:
	
	rotate_x(basis.z.signed_angle_to(-$"../PlayerCamera".basis.z, Vector3.RIGHT))
	
	if Input.is_action_just_pressed("attack") && $AttackTimer.is_stopped():
		var rocket = attack.instantiate()
		get_tree().current_scene.add_child(rocket)
		rocket.look_at((get_parent().transform.basis*transform.basis).z*-1)
		#rocket.rotate_y(basis.z.signed_angle_to(-$"../PlayerCamera".basis.z, Vector3.RIGHT))
		#rocket.rotation = $"../PlayerCamera".rotation
		rocket.global_position = global_position
		
		

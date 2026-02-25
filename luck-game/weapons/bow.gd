extends CharacterBody3D

var attack: PackedScene = preload("res://weapons/arrow.tscn")

func _physics_process(delta: float) -> void:
	
	rotate_x(basis.z.signed_angle_to(-$"../PlayerCamera".basis.z, Vector3.RIGHT))
	
	$"../UI/Attack".max_value = .5
	$"../UI/Attack".value = .5-$ArrowCooldown.time_left

	$"../UI/Special".max_value = 2
	$"../UI/Special".value = 2-$SpecialCooldown.time_left

	if Input.is_action_just_pressed("attack") && $ArrowCooldown.is_stopped():
		var arrow = attack.instantiate()
		get_tree().current_scene.add_child(arrow)
		arrow.look_at((get_parent().transform.basis*transform.basis).z*-1)
		arrow.global_position = global_position
		$ArrowCooldown.start();
	
	if Input.is_action_just_pressed("special") && $SpecialCooldown.is_stopped():
		for i in range(-1,2):
			for j in range(-1,2):
				var arrow = attack.instantiate()
				get_tree().current_scene.add_child(arrow)
				var spread = Vector3(i * 0.06, j * 0.06, 0)
				var look_direction = (get_parent().transform.basis*transform.basis).z*-1
				var final_direction = (look_direction + spread).normalized()
				arrow.look_at(final_direction)
				arrow.global_position = global_position
		$SpecialCooldown.start();

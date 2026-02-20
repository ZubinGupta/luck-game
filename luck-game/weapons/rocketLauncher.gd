extends CharacterBody3D

var attack: PackedScene = preload("res://weapons/rocketAttack.tscn")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") && $AttackTimer.is_stopped():
		var rocket = attack.instantiate()
		get_tree().current_scene.add_child(rocket)
		rocket.look_at(get_parent().transform.basis.z*-1)
		rocket.global_position = global_position
		
		

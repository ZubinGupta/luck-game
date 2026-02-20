extends CharacterBody3D

var attack: PackedScene = preload("res://weapons/arrow.tscn")
var arrowCooldown := false
var arrows := 5;

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") && arrowCooldown == false && arrows > 0:
		var arrow = attack.instantiate()
		get_tree().current_scene.add_child(arrow)
		arrow.look_at(get_parent().transform.basis.z*-1)
		arrow.global_position = global_position
		$ArrowCooldown.start();
		arrowCooldown = true;
		arrows-=1

func _on_arrow_cooldown_timeout() -> void:
	arrowCooldown = false

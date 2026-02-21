extends CharacterBody3D

var explosion_scene: PackedScene = preload("res://weapons/explosion.tscn")

func _physics_process(delta: float) -> void:
	velocity = basis.z.normalized() * 50
	move_and_slide()
	
func kaboom(hit: Node3D):
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

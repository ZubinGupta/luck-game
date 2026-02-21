extends CharacterBody3D

var explosion_scene: PackedScene = preload("res://weapons/explosion.tscn")
var special: bool = false

func _physics_process(delta: float) -> void:
	velocity = basis.z.normalized() * 50
	move_and_slide()
	
func kaboom(hit: Node3D):
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	explosion.special = special
	queue_free()

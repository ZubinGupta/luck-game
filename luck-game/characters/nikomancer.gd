extends CharacterBody3D

var health:int = 40
var nicoScene: PackedScene = preload("res://characters/godotCube.tscn")

func _physics_process(delta: float) -> void:
	var target = global.playerPos
	target.y = global_position.y
	look_at(target)
	velocity = Vector3.DOWN
	move_and_slide()

func hitPlayer(body: Node3D) -> void:
	$"../Player".takeDmg(3, 20, global_position)

func take_damage(amount: int):
	print("Nikomancer took "+str(amount)+" dmg, nikomancer at ", health, " hp")
	health -= amount
	if(health <= 0):
		queue_free()

func spawnNico() -> void:
	var nico = nicoScene.instantiate()
	get_tree().current_scene.add_child(nico)
	nico.global_position = global_position

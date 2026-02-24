extends CharacterBody3D

var health = 30
var direction = 1
var speed = 7
var shuriken = preload("res://characters/shuriken.tscn")

func _physics_process(_delta: float) -> void:
	var target = global.playerPos
	target.y = global_position.y
	look_at(target)
	
	velocity = basis.x.normalized() * speed * direction
	velocity.y = -1
	
	move_and_slide()

func take_damage(amount: int):
	print("Ninja took "+str(amount)+" dmg, ninja at ", health, " hp")
	health -= amount
	if(health <= 0):
		queue_free()

func changeDir() -> void:
	direction *= -1

func throwShuriken() -> void:
	#print("trying to throw shuriken")
	if (global_position-$"../Player".global_position).length() < 60:
		var projectiles = shuriken.instantiate()
		get_tree().current_scene.add_child(projectiles)
		projectiles.global_position = global_position
		projectiles.rotation = rotation

func hitPlayer(body: Node3D) -> void:
	print(body, "ninja")
	$"../Player".takeDmg(3, 20, global_position)

extends CharacterBody3D
const SPEED = 16
var health := 10

func _physics_process(_delta: float) -> void:
	var target = global.playerPos
	target.y = global_position.y
	look_at(target)
	var direction = global_position.direction_to(target)
	velocity = direction * SPEED
	
	if not is_on_floor():
		velocity.y += -1
	else:
		velocity.y = 0
	
	move_and_slide()

	
func take_damage(amount: int):
	print("Took "+str(amount)+" dmg")
	health -= amount
	if(health <= 0):
		queue_free()


func hitPlayer(body: Node3D) -> void:
	print(body, "nicocube")
	$"../Player".takeDmg(2, 20, global_position)

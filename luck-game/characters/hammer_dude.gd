extends CharacterBody3D
const SPEED = 12
var health := 30
var active := false;
const JUMP_FORCE = 500
const JUMP_DISTANCE = 20.0
var can_jump = true;


func _physics_process(_delta: float) -> void:
	var target = global.playerPos
	target.y = global_position.y
	look_at(target)
	var direction = global_position.direction_to(target)
	velocity = direction * SPEED
	
	if not is_on_floor():
		if(active == true):
			velocity.y += -10
		else:
			velocity.y += -1
	else:
		velocity.y = 0
		active = false
		
	if(global_position.distance_to(target) < JUMP_DISTANCE and can_jump):
		jump(direction)
	
	if($JumpCD.is_stopped()): can_jump = true
	
	move_and_slide()

func jump(direction: Vector3):
	velocity.y = JUMP_FORCE
	velocity.x = direction.x * SPEED * 1.5 
	velocity.z = direction.z * SPEED * 1.5
	can_jump = false
	active = true
	$JumpCD.start()
	


	
func take_damage(amount: int):
	print("Took "+str(amount)+" dmg")
	health -= amount
	if(health <= 0):
		queue_free()


func hitPlayer(body: Node3D) -> void:
	if(active):
		print(body, "hammerDude")
		$"../Player".takeDmg(7, 20, global_position)

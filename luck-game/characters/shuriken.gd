extends CharacterBody3D

var speed = 20

func _physics_process(_delta: float) -> void:
	velocity = speed * -basis.z
	move_and_slide()
	
	$Model.rotate_y(PI/12)
	
	
func hitPlayer(body: Node3D) -> void:
	print(body, "shuriken")
	$"../Player".takeDmg(3, 15, global_position)
	call_deferred("rip")

func take_damage(amount: int):
	call_deferred("rip")
	
func hitWall(_body: Node3D) -> void:
	call_deferred("rip")

func lifespan() -> void:
	call_deferred("rip")

func rip():
	queue_free()

extends CharacterBody3D

# camera
@onready
var camera: Camera3D = $PlayerCamera # the player's camera
var camTargetPos: Vector3 = Vector3(-.9, .9, 0) # point where the camera rotates around compared to player
var camRotatedTarget: Vector3 = camTargetPos
var camTargetDistance: float = 2 # how far away the camera tries to be (max distance)
var camMaxDistance: float = 3
var camBaseDistance: float = 2
var camMinDistance: float = 1
var camScrollSpeed: float = .2
var camCurrentDistance: float = 2 # the camera's current distance from its (rotated) target position
var camZoomSpeed: float = .05 # how fast the camera zooms in
@onready
var camRay: RayCast3D = $CameraRay # the raycast that detects if the camera clips into a wall
var camRotationAngle: float = 0 # the cameras current rotation
var angleChange: bool = false # if the cameras angle is exactly what it should be calculated as (helps remove godot being dumb with its signed_angle_to function)
@onready
var camVertRay: RayCast3D = $CamVertRay # raycast to adjust targetPos vertically
@onready
var camHorRay: RayCast3D = $CamHorRay # raycast to adjust targetPos horizontally

# movement
var normalVelocity: Vector3 = Vector3(0,0,0) # the player's walking & gravity velocity, without accounting for rotation
var speed: float = 15 # the player's speed
var movementChangeRate: float = 3 # how fast velocity changes when you press a button
var rotationSpeed: float = .15 # how fast the player's model rotates towards the velocity
var rotationToCam: bool = false # if the body is rotating towards the camera instead of towards velocity
var jumpAmount: float = 24 # how much you jump
var gravity: Vector3 = Vector3(0, -1, 0) # how much gravity is there
var useGravity: bool = true # if gravity is being added to the player's velocity
#var bowSlowdown: float = 1 # a percentage (1=normal, anything else is slower)

# misc
@onready
var model: Node3D = $PlayerModel # the player's model
@onready
var modelScale: Vector3 = $PlayerModel.basis.get_scale() # the model's scale in the editor

func _ready() -> void:
	camTargetDistance = global.playerZoom
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	# change level here
	#if level == 0: # music should probably be played by something else (world file? smth global)
	#	music.stream = load("res://Music/testTrack.ogg")
	#	music.play()
	camVertRay.target_position = Vector3(0, camTargetPos.y, 0)
	camHorRay.target_position = Vector3(camTargetPos.x, 0, 0)
	
	#Put the reticle in the center of the screen
	#reticle.position = get_viewport().size / 2
	#Set the default checkpoint to where the player starts in the scene
	#fixReticle() #so the ui doesnt flash to the top left on reload

func _physics_process(_delta: float) -> void:
	#fixReticle()                                                               
	if Input.is_action_just_pressed("pause"):
		global.paused = !global.paused
		#$UILayer/PauseScreen.visible = global.paused
		if not global.paused: # could be more efficient but whatever
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			Input.warp_mouse(Vector2(300, 300))
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
	if global.paused:
		return
		
	
	# camera -------------------------------------------------------------------------------------------------------------------------------------------------------
	# rotating camera based on mouse movement
	var zoomSlowdown = 1
	#var zoomSlowdown = bowSlowdown
	#if(zoomSlowdown<.5):
	#	zoomSlowdown = .5
	camera.transform = camera.transform.rotated(Vector3.UP, (get_viewport().get_mouse_position().x-300)*-global.sensitivity*zoomSlowdown)
	var tempCamRotation = camera.transform.rotated(camera.transform.basis.x.normalized(), (get_viewport().get_mouse_position().y-300)*-global.sensitivity*zoomSlowdown)
	#camera.transform = camera.transform.rotated(camera.transform.basis.x.normalized(), (get_viewport().get_mouse_position().y-300)*-sensitivity)
	if abs(tempCamRotation.basis.get_euler().z) <= 3 and tempCamRotation.basis.get_euler().z < 0:
		#print("yay")
		#print(tempCamRotation.basis.get_euler().z)
		camera.transform = tempCamRotation
		#camera.transform.basis.from_euler(Vector3(camera.transform.basis.get_euler().x, camera.transform.basis.get_euler().y, -.00001), 3)
	else:
		#print("AAAAAAAAAAAAAA")
		#print(tempCamRotation.basis.get_euler().z)
		if tempCamRotation.basis.get_euler().x > 0:
			camera.transform.basis.from_euler(Vector3(PI/2, camera.transform.basis.get_euler().y, -.00001), 3)
			
	# rotating the point the camera revolves around & making sure to avoid weirdness
	var tempRotationAngle: float = Vector3(0,0,1).signed_angle_to(Vector3(-camera.basis.z.x, 0, -camera.basis.z.z), Vector3(0,1,0))
	if (tempRotationAngle>0) != (camRotationAngle>0) and not angleChange:
		if(tempRotationAngle>2):
			camRotationAngle = PI
		elif(tempRotationAngle<-2):
			camRotationAngle = -PI
		else: 
			camRotationAngle = 0
		angleChange = true
	else:
		camRotationAngle = tempRotationAngle
		angleChange = false
	
	
	# changing camera target point based on if its clipping into a wall
	var tempCamTarget = camTargetPos
	camVertRay.force_raycast_update()
	if camVertRay.is_colliding():
		tempCamTarget.y = (camVertRay.get_collision_point().y - global_position.y) * .9
	camHorRay.position.y = tempCamTarget.y 
	camHorRay.target_position = tempCamTarget.rotated(Vector3(0,1,0), camRotationAngle)
	camHorRay.target_position.y = 0
	camHorRay.force_raycast_update()
	if camHorRay.is_colliding():
		tempCamTarget.x = -(camHorRay.get_collision_point()-camHorRay.global_position).length() * .9
	# rotated target position for camera stuff 
	camRotatedTarget = tempCamTarget.rotated(Vector3(0,1,0), camRotationAngle)
	
	#print("2:",camera.transform.basis.get_euler())
	# for debugging if this doesn't work
	#print(camera.global_transform.basis.get_euler().x)
	
	#adjusting target distance based on mouse scroll
	if(Input.is_action_just_released("zoomout")):
		camTargetDistance += camScrollSpeed
		if(camTargetDistance>camMaxDistance):
			camTargetDistance = camMaxDistance
		global.playerZoom= camTargetDistance
			
	if(Input.is_action_just_released("zoomin") && camTargetDistance > camMinDistance):
		camTargetDistance -= camScrollSpeed
		if(camTargetDistance<camMinDistance):
			camTargetDistance = camMinDistance
		global.playerZoom= camTargetDistance
	
	# adjusting cam target distance based on bow slowdown
	var tempTargetDistance = camTargetDistance
	#if bowSlowdown != 1:
	#	tempTargetDistance = camBaseDistance * bowSlowdown
	
	# detecting collision & adjusting length
	var newCamPos: Vector3 = camRotatedTarget + camera.transform.basis.z * tempTargetDistance
	camRay.position = camRotatedTarget
	camRay.target_position = newCamPos-camRotatedTarget
	camRay.force_raycast_update()
	if camRay.is_colliding(): # colliding with smth, cant be fully zoomed out
		#camera.global_position = camRay.get_collision_point()
		#var distance: Vector3 = camera.position-camRotatedPos
		var distance: Vector3 = camRay.get_collision_point()-position-camRotatedTarget
		camCurrentDistance = sqrt(distance.x*distance.x+distance.y*distance.y+distance.z*distance.z) * .9
		camera.position = camRotatedTarget + camera.transform.basis.z * (camCurrentDistance)
		#print("colliding bro now")
	elif camCurrentDistance == tempTargetDistance: # target distance = current distance, yay
		camera.position = newCamPos
		camCurrentDistance = tempTargetDistance
	elif camCurrentDistance > tempTargetDistance: # current distance > target distance, zoom in
		camCurrentDistance = camCurrentDistance-camZoomSpeed
		if camCurrentDistance < tempTargetDistance:
			camCurrentDistance = tempTargetDistance
		camera.position = camRotatedTarget + camera.transform.basis.z * (camCurrentDistance)
	else: # current distance < target distance, zoom out
		camCurrentDistance = camCurrentDistance+camZoomSpeed
		if camCurrentDistance > tempTargetDistance:
			camCurrentDistance = tempTargetDistance
		camera.position = camRotatedTarget + camera.transform.basis.z * (camCurrentDistance)

	# camera end --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	# movement -------------------------------------------------------------------------------------------------------------------------------------------------------
	# moving if pressing a button
	if (Input.get_axis("backward", "forward") != 0 or Input.get_axis("right", "left") != 0):
		# movement normalized so diagonal isn't faster than straight
		var targetMovement: Vector3 = Vector3(Input.get_axis("left", "right"), 0, Input.get_axis("forward", "backward")).normalized() * speed
		#rotating target movement
		var camDiff: Vector3 = camera.position-camRotatedTarget
		camDiff.y = 0
		var camAngle = Vector3(0,0,1).signed_angle_to(camDiff, Vector3(0,1,0))
		targetMovement = targetMovement.rotated(Vector3.UP, camAngle)
		
		#rotating model based off of rotated movement
		var moveAngle = Vector3(0,0,1).signed_angle_to(targetMovement, Vector3(0,1,0))
		model.basis = model.basis.orthonormalized().slerp(Basis(Vector3.UP, moveAngle), rotationSpeed).scaled(modelScale)
		
		# adding in vertical velocity cuz it would've messed up the normalization
		targetMovement.y += normalVelocity.y 
		normalVelocity = normalVelocity.move_toward(targetMovement, movementChangeRate)
		
	else: # stopping
		normalVelocity = normalVelocity.move_toward(Vector3(0, normalVelocity.y, 0), movementChangeRate)
		var moveAngle = Vector3(0,0,1).signed_angle_to(Vector3(model.basis.z.x, 0, model.basis.z.z), Vector3(0,1,0))
		model.basis = model.basis.orthonormalized().slerp(Basis(Vector3.UP, moveAngle).orthonormalized(), rotationSpeed).scaled(modelScale)
	
	# setting velocity & movin/slidin
	velocity = normalVelocity
	move_and_slide()
	
	# setting mouse position at the end of the frame
	Input.warp_mouse(Vector2(300, 300)) # godot mouse stuff is scuffed when locked so i made my own locked ._.
	# i hate reticles
	#call_deferred("fixReticle")

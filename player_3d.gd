extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouseSensitivity := 0.25

@export_group("Movement")
@export var moveSpeed := 8.0
@export var acceleration := 20.0

var cameraInputDirection := Vector2.ZERO

@onready var cameraPivot: Node3D = %CameraPivot
@onready var camera: Camera3D = %Camera3D
@onready var mesh: MeshInstance3D = %MeshInstance3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://mainMenu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	var isCameraMotion := (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if isCameraMotion:
		cameraInputDirection = event.screen_relative * mouseSensitivity

func _physics_process(delta: float) -> void:
	#print(cameraInputDirection.x)
	#print(cameraInputDirection.y)
	cameraPivot.rotation.x -= cameraInputDirection.y * delta
	cameraPivot.rotation.x = clamp(cameraPivot.rotation.x, -PI / 2.0, PI / 2.0)
	cameraPivot.rotation.y -= cameraInputDirection.x * delta
	cameraInputDirection = Vector2.ZERO
	
	var rawInput := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var forward := camera.global_basis.z
	var right := camera.global_basis.x
	
	var moveDirection := forward * rawInput.y  + right * rawInput.x
	moveDirection.y = 0.0
	moveDirection = moveDirection.normalized()
	#print(moveDirection.x, moveDirection.y, moveDirection.z)
	
	velocity = velocity.move_toward(moveDirection * moveSpeed, acceleration * delta)
	move_and_slide()
	
	print(mesh.rotation.x)
	print(mesh.rotation.z)
	mesh.rotation.x += moveDirection.z * 0.2
	mesh.rotation.z -= moveDirection.x * 0.2

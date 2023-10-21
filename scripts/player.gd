extends CharacterBody3D
@onready var visuals=$visuals
@onready var camara = $camara
@onready var animation_player = $visuals/mixamo_base/AnimationPlayer
const SPEED = 4.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var sentido_horizontal= -0.3
var sentido_vertical= -0.2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
#Funcion para capturar el movimiento del mouse
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x)*sentido_horizontal)
		visuals.rotate_y(deg_to_rad(-event.relative.x)*sentido_horizontal)
		camara.rotate_x(deg_to_rad(event.relative.y)*sentido_vertical)
		

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.SALTAR!!
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("left_click") and is_on_floor():
		animation_player.play("kick")
	
	#Btn izq del mouse y pega patadas
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var input_dir = Input.get_vector("left_tecla","rigth_tecla","up_tecla","down_tecla")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#var direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
	#print(direction)
	
	if Input.is_action_just_pressed("left_click") and is_on_floor():
		animation_player.play("kick") #patada
		velocity.x = 0
		velocity.z = 0

	#print(direction)
	#print(velocity.x)
	if direction:
		if animation_player.current_animation != "walking" and animation_player.current_animation != "kick":
			animation_player.play("walking")
			visuals.look_at(position + direction)#para que doble
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idle" and animation_player.current_animation != "kick":
			animation_player.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	

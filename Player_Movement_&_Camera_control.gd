extends KinematicBody #This calls for the player node basically
var speed = 10
var mouse_sensitivity = 0.09
var h_accelaration = 6
var air_acceleration = 1
var normal_acceleration = 6
var gravity = 18.4
var jump = 10
var full_contact = false 

var h_velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var direction = Vector3()#basically calls for the vector 3 commands



onready var head = $Head #this calls for the head node when it's loaded
onready var ground_check = $GroundCheck #this calls for the head node when it's loaded
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #keeps the mouse inside the game window
 
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) #translates mouse movement to horizontal rotation
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) #rotates the entire head node according to mouse movement
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))#forbids looking up or down more than 89 degrees

func _physics_process(delta):
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	direction = Vector3()
		
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_accelaration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_accelaration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_accelaration = normal_acceleration
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
		
	elif Input.is_action_pressed("backward"):
		direction += transform.basis.z
		
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
		
	elif Input.is_action_pressed("right"):
		direction += transform.basis.x
		
	
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_accelaration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
# warning-ignore:return_value_discarded
	move_and_slide(movement, Vector3.UP)

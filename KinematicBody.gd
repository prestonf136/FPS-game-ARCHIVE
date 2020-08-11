extends KinematicBody

var speed = 7
var acceleration = 10
var gravity = 0.09
var jump = 10

var mouse_sensitivity = -0.03
var mouse_sens_pos = 0.03
var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

onready var head = $head/Cam
onready var hand = $head/Hands
onready var handloc = $head/Handloc
const SWAY = 15
onready var aimcast = $head/Hands/glock/RayCast
const damage = 100

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hand.set_as_toplevel(true)
	
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(event.relative.x * -mouse_sens_pos)) 
		head.rotate_x(deg2rad(event.relative.y * mouse_sens_pos)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-55), deg2rad(50))
		
func _process(delta):
	hand.global_transform.origin = handloc.global_transform.origin
	hand.rotation.y = lerp_angle(hand.rotation.y,rotation.y,40 * delta)
	hand.rotation.x = lerp_angle(hand.rotation.x,rotation.x,45 * delta)
	
	if Input.is_action_just_pressed("fire"):
		if aimcast.is_colliding():
				var target = aimcast.get_collider()
			
				if target != null && target.is_in_group("Enemy"):
					print("hit enemy")
					target.health -= damage
		
		#var audio = $head/Hands/glock/glockshot
		#audio.play()
		#yield(get_tree().create_timer(0.80), "timeout")
		#audio.stop()
	
func _physics_process(delta):
	
	direction = Vector3()
	
# warning-ignore:return_value_discarded
	move_and_slide(fall, Vector3.UP)
	
	if Input.is_action_just_pressed("ui_escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if not is_on_floor():
		fall.y -= gravity
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		
	
	if Input.is_action_pressed("ui_up"):
	
		direction = transform.basis.z
	
	elif Input.is_action_pressed("ui_down"):
		
		direction -= transform.basis.z
		
	if Input.is_action_pressed("ui_left"):
		
		direction += transform.basis.x			
		
	elif Input.is_action_pressed("ui_right"):
		
		direction -= transform.basis.x
			
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 


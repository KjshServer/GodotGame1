extends CharacterBody2D

var speed_saw_1:float = 200.0
var raycast_floor_position_x:float = 20.0
var raycast_wall_target_position_x:float = 20.0
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = $animation
@onready var raycast_floor_detection = $raycast_floor_detection
@onready var raycast_wall_detection = $raycast_wall_detection

func _ready():
	velocity.x = speed_saw_1
	raycast_floor_detection.position.x = raycast_floor_position_x
	raycast_wall_detection.target_position.x = raycast_wall_target_position_x

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if not raycast_floor_detection.is_colliding() or raycast_wall_detection.is_colliding():
		velocity.x *= -1
		raycast_floor_detection.position.x *= -1
		raycast_wall_detection.target_position.x *= -1
		animation.flip_h = velocity.x > 0

	move_and_slide()

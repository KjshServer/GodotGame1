extends CharacterBody2D

var speed_walk:float = 300.0
var speed_run:float = 500.0
var jump_velocity:float = -400.0
var direction:float = 0.0
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var wait_fall:float = 0.1
var raycast_dimension:float = 10.5
var max_jump:int = 2
var count_jump:int = 0
var is_running:bool = false
var is_allow_animation:bool = false
var is_leaved_floor:bool = false
var is_had_jump:bool = false
var is_double_jump:bool = false
var is_stuck_on_wall:bool = false

@onready var delay_fall = $delay_fall
@onready var wall_jump = $wall_jump
@onready var animation = $animation

func _ready():
	delay_fall.wait_time = wait_fall
	delay_fall.one_shot = true
	animation.play("appearing")
	wall_jump.target_position.x = raycast_dimension
	wall_jump.target_position.y = 0

func _physics_process(delta):
	if is_on_floor():
		is_leaved_floor = false
		is_had_jump = false
		count_jump = 0
	else:
		if not is_leaved_floor:
			delay_fall.start()
			is_leaved_floor = true

		velocity.y += gravity * delta

	if Input.is_action_just_pressed("action_jump") and right_to_jump():
		if count_jump == 1:
			is_double_jump = true

		count_jump += 1
		velocity.y = jump_velocity

	if Input.is_action_pressed("action_run"):
		is_running = true
	else:
		is_running = false

	direction = Input.get_axis("move_left", "move_right")
	if direction:
		if is_running:
			velocity.x = direction * speed_run
		else:
			velocity.x = direction * speed_walk
	else:
		if is_running:
			velocity.x = move_toward(velocity.x, 0, speed_run * 0.05)
		else:
			velocity.x = move_toward(velocity.x, 0, speed_walk * 0.1)

	if wall_jump.get_collider():
		if wall_jump.get_collider().is_in_group("wall_jump"):
			if velocity.y > 0:
				count_jump = 0
				velocity.y = 0
				is_stuck_on_wall = true 
			else: is_stuck_on_wall = false
		else: is_stuck_on_wall = false
	else: is_stuck_on_wall = false
	
	move_and_slide()
	player_animation()

func right_to_jump():
	if is_had_jump:
		if count_jump < max_jump: return true
		else: return false

	if is_on_floor() or is_stuck_on_wall:
		is_had_jump = true
		return true
	elif not delay_fall.is_stopped():
		is_had_jump = true
		return true

func player_animation():
	if direction < 0:
		animation.flip_h = true
		wall_jump.target_position.x = -raycast_dimension
	elif direction > 0:
		animation.flip_h = false
		wall_jump.target_position.x = raycast_dimension
		
	if is_double_jump:
		is_double_jump = false
		is_allow_animation = false
		animation.play("double_jump")
	
	if not is_allow_animation: return
	
	if is_stuck_on_wall:
		animation.play("wall_jump")
	else:
		if velocity.x == 0:
			animation.play("idle")
		elif velocity.x < 0:
			animation.play("run")
		elif velocity.x > 0:
			animation.play("run")

		if velocity.y < 0:
			animation.play("jump")
		if velocity.y > 0:
			animation.play("fall")

func fruit_collect(fruit_type):
	var fruit_point:String = fruit_type + "_points"
	var gained_pints = globals[fruit_point]

	globals.fruit_count += gained_pints

func _on_animations_animation_finished():
	is_allow_animation = true

func _on_damage_detection_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	globals.player_health -= 10

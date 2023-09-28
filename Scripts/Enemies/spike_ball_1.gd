extends Node2D

var raycast_init_target_position_y:float = 36.0 
var raycast_target_position_y:float = 6.0

var is_floor_detect:bool = false
var is_safe_time:bool = false

@onready var animation = $animation
@onready var raycast_floor_detection = $raycast_floor_detection
@onready var safe_time = $safe_time
@onready var spiked_ball = $spiked_ball

func _ready():
	raycast_floor_detection.target_position.y = raycast_init_target_position_y
	safe_time.start()

func _process(_delta):
	if not is_floor_detect and is_safe_time:
		raycast_floor_detection.target_position.y += raycast_target_position_y

		if raycast_floor_detection.get_collider():
			raycast_floor_detection.target_position.y -= raycast_target_position_y
			is_floor_detect = true

			init_spike_ball()
 
func init_spike_ball():
	var number_of_chains:float = (raycast_floor_detection.target_position.y - raycast_init_target_position_y) / raycast_target_position_y

	spiked_ball.position.y += (number_of_chains * raycast_target_position_y)

	for i in range(number_of_chains):
		var new_ring = preload("res://Scenes/Enemies/spike_ball_1/chain.tscn").instantiate()

		new_ring.position = Vector2(0, (6 * (i + 1)))
		self.add_child(new_ring)

	animation.play("regular_move")

func _on_safe_time_timeout():
	is_safe_time = true

func _on_area_collision_with_map_body_entered(_body):
	animation.speed_scale *= -1

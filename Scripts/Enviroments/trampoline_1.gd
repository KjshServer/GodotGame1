extends Node2D

var impulse:float = 800.0

@onready var animation = $animation

func _on_activation_area_body_entered(body):
	animation.play("launch")
	body.velocity.y = -impulse

@tool
extends Node2D

@export_enum(
	"apple",
	"banana",
	"cherry",
	"kiwi",
	"melon",
	"orange",
	"pineapple",
	"strawberry"
) var fruit_type:String = "apple":
	set(value):
		fruit_type = value
		$animation.animation = fruit_type

@onready var animation = $animation

func _ready():
	if not Engine.is_editor_hint():
		animation.play(fruit_type)

func _on_area_collet_body_entered(body):
	if body.has_method("fruit_collect"):
		body.fruit_collect(fruit_type)

	animation.play("collected")

func _on_animation_animation_finished():
	self.queue_free()

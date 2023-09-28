extends CanvasLayer

var timer_game:float = 360.0

@onready var health_progress = $health_progress
@onready var fruit_progress = $fruit_progress
@onready var time_text = $time_text

func _ready():
	health_progress.value = globals.player_health
	globals.fruit_count

func _process(delta):
	health_progress.value = globals.player_health
	fruit_progress.value = globals.fruit_count

	if timer_game > 0:
		timer_game -= delta

		if timer_game < 74.0:
			time_text.add_theme_color_override("font_color", "ff7d30")
		if timer_game < 37.0:
			time_text.add_theme_color_override("font_color", "d11237")

		if timer_game < 100.0 and timer_game > 10.0:
			time_text.text = "0" + str(int(timer_game))
		elif timer_game < 10.0:
			time_text.text = "00" + str(int(timer_game))
		else:
			time_text.text = str(int(timer_game))
	else:
		timer_game = 0.0
		time_text.text = "000"

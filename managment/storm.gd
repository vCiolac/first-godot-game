extends Node2D
@onready var light_timer = $TimerLight
@onready var thunder_timer = $TimerThunder

func _ready():
	light_timer.start(1)
	thunder_timer.start(0.5)

func _on_timer_light_timeout():
	var number = randi() % 2 + 1
	if number == 1:
		$Light.emitting = true
	else:
		$Light2.emitting = true
	light_timer.start(number)

func _on_timer_thunder_timeout():
	var number = randi() % 8 + 1
	if number == 1:
		$ThunderS.play()
		$Thunder.emitting = true
	else:
		$Thunder2.emitting = true
	thunder_timer.start(number)

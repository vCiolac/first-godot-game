extends CanvasLayer

func _process(_delta):
	set_spider_on()

func set_spider_on():
	if transition.instinct == true:
		$Instinct.visible = true
	else:
		$Instinct.visible = false

func _on_area_2d_mouse_entered():
	$Instinct/baloon.visible = true

func _on_area_2d_mouse_exited():
	$Instinct/baloon.visible = false

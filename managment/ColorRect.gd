extends ColorRect

var darkness_speed = 0.2  # Adjust this value to control the speed of darkening
var target_alpha = 1.0  # Adjust this value to control the final darkness level
var current_alpha = 0.0

func _process(delta):
	current_alpha += darkness_speed * delta
	current_alpha = clamp(current_alpha, 0.0, target_alpha)
	self.color.a = current_alpha

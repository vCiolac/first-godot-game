extends CharacterBody2D
	
func _process(_delta):
	if State.has_walked == "waiting" and Input.is_action_pressed("left") or State.has_walked == "waiting" and Input.is_action_pressed("right"):
		player_pressed_wasd()
	if State.has_jump == "go_jump" and Input.is_action_pressed("jump"):
		player_jumped()
		
func player_jumped():
	State.has_jump = "true"
	
func player_pressed_wasd():
	State.has_walked = "true"
	
func _on_actionable_body_entered(_body):
	$AskBox.visible = false
	$Ballon.visible = true


func _on_actionable_body_exited(_body):
	$AskBox.visible = true
	$Ballon.visible = false

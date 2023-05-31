extends CharacterBody2D

#func _unhandled_input(event):
#	if event.is_action_pressed("ui_text_submit"):
#		var overlapping_bodies = $Actionable.get_overlapping_bodies()
#		if overlapping_bodies.size() > 0:
#			use_dialogue()
#
#func use_dialogue():
#	var dialogue = $Dialogue
#	if dialogue:
#		dialogue.start()
	
func _process(_delta):
	if State.has_walked == "waiting" and Input.is_action_pressed("left") or State.has_walked == "waiting" and Input.is_action_pressed("right"):
		player_pressed_wasd()
	if State.has_jump == "go_jump" and Input.is_action_pressed("jump"):
		player_jumped()
		
func player_jumped():
	print('pulei')
	State.has_jump = "true"
	print('state', State.has_jump)
	
func player_pressed_wasd():
	print('andei')
	State.has_walked = "true"
	print('state', State.has_walked)
	
func _on_actionable_body_entered(_body):
	$AskBox.visible = false
	$Ballon.visible = true


func _on_actionable_body_exited(_body):
	$AskBox.visible = true
	$Ballon.visible = false

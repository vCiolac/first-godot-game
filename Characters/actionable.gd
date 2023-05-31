extends Area2D

const ballon = preload("res://managment/balloon.tscn")

@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "start"

func action() -> void:
	var balloon: Node = ballon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)

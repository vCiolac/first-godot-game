extends CanvasLayer

@export_file("*.json") var d_file
@export var current_dialogue_id = 0
@export var dialogue = []
@export var d_active = false

func _ready():
	$"Yellow Board".visible = false
	
func start():
	if d_active:
		return
	d_active = true
	$"Yellow Board".visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

func load_dialogue():
	#Converts linked JSON file into a string
	var json_as_text = FileAccess.get_file_as_string(d_file)
	#Parses JSON into a dictionary
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		return json_as_dict

func _input(event):
	if not d_active:
		return
	if event.is_action_pressed("ui_text_submit"):
		next_script()
			
func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		$Timer.start()
		$"Yellow Board".visible = false
		return
	$"Yellow Board/Name".text = dialogue[current_dialogue_id]['name']
	$"Yellow Board/Chat".text = dialogue[current_dialogue_id]['text']


func _on_timer_timeout():
	d_active = false

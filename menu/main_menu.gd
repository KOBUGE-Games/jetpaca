
extends ReferenceFrame

# member variables here, example:
# var a=2
# var b="textvar"

func _on_play_pressed():
	print("please load it?")
	get_tree().get_root().get_node("main").goto_scene("res://menu/stage_select.xml")
	
func _on_settings_pressed():
	pass

func _input(event):
	if event.is_action("menu_accept") && event.pressed:
		_on_play_pressed()

func _ready():
	# Initalization here
	get_node("jp_play").show()
	set_process_input(true)
	pass



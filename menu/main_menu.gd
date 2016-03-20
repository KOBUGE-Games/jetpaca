# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends ReferenceFrame

# member variables here, example:
# var a=2
# var b="textvar"

func _on_play_pressed():
	print("please load it?")
	get_tree().get_root().get_node("main").goto_scene("res://menu/stage_select.tscn")
	
func _on_settings_pressed():
	pass

func _input(event):
	if event.is_action("ui_accept") && event.pressed:
		_on_play_pressed()

func _ready():
	# Initalization here
	get_node("jp_play").show()
	set_process_input(true)
	pass



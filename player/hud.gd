# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends ReferenceFrame

# member variables here, example:
# var a=2
# var b="textvar"

const LIFE_MAX=2

func _on_pause_pressed():
	if get_tree().is_paused():
		get_node("back").hide()
	else:
		get_node("back").show()
	get_tree().set_pause(!get_tree().is_paused())

	#var gd = get_tree().get_root().get_node("game_data")
	#var wpc = gd.current_world.path
	#get_tree().get_root().get_node("main").goto_scene(wpc)
		
func _on_back_pressed():
	get_tree().set_pause(false)
	get_tree().get_root().get_node("main").goto_scene("res://menu/stage_select.xml")


func hint_show(text):
	get_node("anim").get_animation("fadein").track_set_key_value(0,1,text)
	get_node("anim").play("fadein")

func hint_hide():
	get_node("anim").play("fadeout")

func set_energy(level):
	for x in range(LIFE_MAX):
		var n = get_node("life/heart_"+str(x))
		if (x<level):
			n.set_frame(1)
		else:
			n.set_frame(0)
			

func set_large_fruit_on(idx):
	get_node("coins/base/large_coin_"+str(idx)).set_frame(1)

func set_fruit_count(count):
	get_node("fruit_count/amount").set_text(str(count))

func set_life_count(count):
	get_node("fruit_count/life_amount").set_text(str(count))

func update_keys():
	var gd = get_tree().get_root().get_node("game_data")
	for x in range(3):
		var n = get_node("keys/key_"+str(x))
		if (gd.current_keys[x]):
			n.show()
		else:
			n.hide()
			
func _ready():
	# Initalization here
	var gd = get_tree().get_root().get_node("game_data")
	var cw = get_tree().get_root().get_node("game_data").current_world
	for x in range(cw.large_fruits.size()):
		if (cw.large_fruits[x]):
			set_large_fruit_on(x)
	set_life_count(gd.life_count)
	update_keys()
	#make attack area the size of the screen
			



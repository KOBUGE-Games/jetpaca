# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends ReferenceFrame

const LIFE_MAX = 2

func _on_pause_pressed():
	if get_tree().is_paused():
		get_node("back").hide()
	else:
		get_node("back").show()
	get_tree().set_pause(!get_tree().is_paused())

func _on_back_pressed():
	get_tree().set_pause(false)
	main.goto_scene("res://menu/stage_select.tscn")

func hint_show(text):
	get_node("anim").get_animation("fadein").track_set_key_value(0, 1, text)
	get_node("anim").play("fadein")

func hint_hide():
	get_node("anim").play("fadeout")

func set_energy(level):
	for x in range(LIFE_MAX):
		var n = get_node("life/heart_" + str(x))
		if x < level:
			n.set_frame(1)
		else:
			n.set_frame(0)

func set_big_coin_on(idx):
	get_node("coins/base/large_coin_" + str(idx)).set_frame(1)

func set_fruit_count(count):
	get_node("fruit_count/amount").set_text(str(count))

func set_life_count(count):
	get_node("fruit_count/life_amount").set_text(str(count))

func update_keys():
	for x in range(3):
		var n = get_node("keys/key_" + str(x))
		if game_data.current_keys[x]:
			n.show()
		else:
			n.hide()

func _ready():
	var cw = game_data.current_world
	for x in range(cw.big_coins.size()):
		if cw.big_coins[x]:
			set_big_coin_on(x)
	set_life_count(game_data.life_count)
	update_keys()

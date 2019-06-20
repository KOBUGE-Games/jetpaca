# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Area2D

export var fruit_index = 0

var taken = false

func _on_timeout():
	queue_free()

func _on_enter_screen():
	get_node("anim").play("roll")

func _on_exit_screen():
	get_node("anim").stop()

func _on_body_enter(body):
	if not taken and body is preload("res://player/alpaca.gd"):
		print("BODY IN COIN")
		taken = true
		body.add_big_coin(fruit_index)
		print("PRE-SET ", game_data.current_big_coins)
		game_data.current_big_coins[fruit_index] = true
		print("POST-SET ", game_data.current_big_coins)
		get_node("sprite").hide()
		get_node("shine").set_emitting(true)
		get_node("shine_sfx").play()
		get_node("deathclock").start()

func _ready():
	var cw = game_data.current_world
	if cw.big_coins[fruit_index]:
		get_node("sprite").self_modulate.a = 0.5


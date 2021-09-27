# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Control

func _ready():
	get_node("button_play").connect("pressed", self, "play_pressed")
	get_node("button_play").show()

func play_pressed():
	get_tree().change_scene("res://menu/stage_select.tscn")

func settings_pressed():
	pass # TODO: make settings screen

func _input(event):
	if event.is_action("ui_accept") and event.pressed:
		play_pressed()
	if event.is_action("quit") and event.pressed:
		get_tree().quit()

# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Area2D

export(String) var group = ""

func _on_body_enter(body):
	if body extends preload("res://player/alpaca.gd"):
		get_tree().call_group(0, group, "_triggered")

func _enter_tree():
	connect("body_enter", self, "_on_body_enter")

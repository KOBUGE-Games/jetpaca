# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node

class LevelInfo:
	var id = Vector2()
	var big_coins = [false, false, false]
	var max_fruit = 0
	var preview_path = ""
	var path = ""
	var music = ""
	var name = ""
	var enabled = true

var last_level = 0
var last_world = 1
var levels = []

var current_checkpoint = ""
var current_world = null
var current_big_coins = [false, false, false]
var current_keys = [false, false, false]
var life_count = 5

func _init():
	var stage_list = preload("res://stages/stage_list.gd").get_stage_list()
	for stage in stage_list:
		var level = LevelInfo.new()
		level.id = stage.id
		level.path = stage.path + ".tscn"
		level.preview_path= stage.path + ".png"
		level.music = stage.music
		level.enabled = true
		level.name = str(stage.id.x, "-", stage.id.y)
		levels.push_back(level)
		prints("Level:", level.id, "path:", level.path)

func stage_reset():
	life_count = 5
	current_checkpoint = ""
	current_world = null
	current_big_coins = []
	current_keys = [false, false, false]

func get_level(id):
	for level in levels:
		if level.id == id:
			return level
	return null

func set_current_stage(path):
	for level in levels:
		if level.path == path:
			current_world = level
			return
	print("Warning: World not found in list: ", path)
	current_world = LevelInfo.new()
	current_world.path = path

func game_over():
	stage_reset() # Todo: remove alias?

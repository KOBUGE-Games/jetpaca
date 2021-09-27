# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Control

export var column_count = 3
onready var tabs = get_node("items/worlds")

func _ready():
	music.change_music_to("res://music/bgm.ogg")
	add_levels()

func _unhandled_key_input(event):
	if event.is_action("quit") and event.is_pressed() and !event.is_echo():
		back_pressed()

func add_levels():
	var world_tabs = {}
	print("Adding levels...")
	var gave_focus = false

	for level in game_data.levels:
		if !level.enabled:
			continue

		printt("Adding level", level.enabled, level.path)

		if !(level.id.x in world_tabs):
			var tab_center_container = CenterContainer.new()
			tab_center_container.set_name(str("World ", level.id[0]))
			tabs.add_child(tab_center_container)

			var tab_levels_grid = GridContainer.new()
			tab_levels_grid.set_columns(column_count)
			tab_center_container.add_child(tab_levels_grid)
			world_tabs[level.id.x] = tab_levels_grid

		var tab_levels_grid = world_tabs[level.id.x]

		var level_vbox = VBoxContainer.new()

		var level_button = Button.new()
		level_button.set_button_icon(load(level.preview_path))
		level_button.connect("pressed", self, "select_stage", [level])
		level_vbox.add_child(level_button)

		var level_name = Label.new()
		level_name.set_align(Label.ALIGN_CENTER)
		level_name.set_text(level.name)
		level_name.add_font_override("font", preload("res://art/fonts/firasans_bold_26.tres"))
		level_vbox.add_child(level_name)

		if !gave_focus:
			level_button.call_deferred("grab_focus")
			gave_focus = true

		tab_levels_grid.add_child(level_vbox)

func select_stage(stage):
	game_data.current_world = stage
	music.change_music_to(stage.music)
	main.goto_scene(stage.path)

func back_pressed():
	get_tree().change_scene("res://menu/main_menu.tscn")

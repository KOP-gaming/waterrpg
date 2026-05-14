extends Node2D

var main_menu = preload("res://scenes/menu.tscn")

@onready var ui_layer = $CanvasLayer

func _input(event):
	if event.is_action_pressed("menu"):

		if get_tree().paused:
			return

		var menu = main_menu.instantiate()

		menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

		ui_layer.add_child(menu)

		get_tree().paused = true

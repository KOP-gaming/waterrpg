extends Node2D

var main_menu = preload("res://scenes/menu.tscn")
var battle = preload("res://scenes/battles/battle1.tscn")

@onready var ui_layer = $CanvasLayer
@onready var battletest = $Battletester
func _ready():
	apply_battle_state()

func apply_battle_state():
	var battles = SaveLoad.Contents_To_Save.get("battles", {})

	if battles.get("battletest", true) == false:
		battletest.monitoring = false


func _input(event):
	if event.is_action_pressed("menu"):

		if get_tree().paused:
			return

		var menu = main_menu.instantiate()

		menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

		ui_layer.add_child(menu)

		get_tree().paused = true




func _on_battletester_body_entered(body: Node2D) -> void:
	print("entered the area")
	var battle_scene = battle.instantiate()
	battle_scene.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	ui_layer.add_child(battle_scene)
	get_tree().paused = true
	
func disable_battle_trigger():
	battletest.monitoring = false

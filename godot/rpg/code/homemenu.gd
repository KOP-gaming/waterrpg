extends Node2D

var main_menu = preload("res://scenes/menu.tscn")
var battle = preload("res://scenes/battles/battle1.tscn")
var inventory = preload("res://scenes/inventory/inventory.tscn")

@onready var ui_layer = $CanvasLayer
func _ready():
	apply_battle_state()

func apply_battle_state():
	var battles = SaveLoad.Contents_To_Save.get("battles", {})



func _input(event):
	if event.is_action_pressed("menu"):
		$CanvasLayer.visible = true

		if get_tree().paused:
			return

		var menu = main_menu.instantiate()

		menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

		ui_layer.add_child(menu)

		get_tree().paused = true
	
	if event.is_action_pressed("inventory"):
		$CanvasLayer.visible = true
		if get_tree().paused:
			return
		
		var inv = inventory.instantiate()
		inv.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		ui_layer.add_child(inv)
		inv.initialize_inventory()
		get_tree().paused = true


func _on_healme_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		State.current_health = State.max_health
		print(State.current_health,  State.max_health)

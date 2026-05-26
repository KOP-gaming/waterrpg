extends Node2D

var main_menu = preload("res://scenes/menu.tscn")
var battle = preload("res://scenes/battles/battle1.tscn")
var inventory = preload("res://scenes/inventory/inventory.tscn")


@onready var ui_layer = $CanvasLayer
@onready var battletest = $Battletester

func _ready():
	get_tree().paused = true
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	apply_battle_state()
	$AnimationPlayer.play("enemy1walkcycle")
	
	

func apply_battle_state():
	var battles = SaveLoad.Contents_To_Save.get("battles", {})

	if battles.get("battletest", true) == false:
		battletest.monitoring = false
		battletest.visible = false



func _input(event):
	if event.is_action_pressed("menu"):

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




func _on_battletester_body_entered(body: Node2D) -> void:
	print("entered the area")
	var battle_scene = battle.instantiate()
	battle_scene.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	ui_layer.add_child(battle_scene)
	get_tree().paused = true
	
func disable_battle_trigger():
	battletest.monitoring = false
	battletest.visible = false
	$shittydrops.visible = true


func _on_backtovillage_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scenes/main_village.tscn")


func _on_saveme_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SaveLoad.save_player_position(body)

extends Control
@onready var player = get_tree().get_first_node_in_group("player")

signal textbox_closed


@export var enemy: Resource

var curent_player_health = 0
var current_enemy_health = 0
var starting_health = 0
var is_defending = false
var enemy_attack_one_liners = [
	"%s makes a Conker's bad fur day reference.",
	"%s shows you some REALLY shitty behavior.",
	"%s wants to show you their diaper.",
	"%s tries to give you watery diarrhea.",
	"%s is looking for a new place to live.... inside your gut.",
	"%s is looking for your large intestine."
]

func _ready() -> void:
	set_health($enemycontainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$enemycontainer/Enemy.texture = enemy.texture
	
	curent_player_health = State.current_health
	current_enemy_health = enemy.health
	starting_health = State.current_health
	
	$TextBox.hide()
	$ActionsPanel.hide()
	display_text("You are chalanged by %s !" % enemy.name) 
	await self.textbox_closed
	$ActionsPanel.show()


func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click") and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")


func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text


func _on_run_pressed() -> void:
	if 90 >= randi_range(0, 100):
		$ActionsPanel.hide()
		display_text("Got away safely.")
		await self.textbox_closed
		get_tree().paused = false
		queue_free()
	else:
		display_text("You try to  run but your legs refuse to move.")
		enemy_turn()


func _on_defend_pressed() -> void:
	if randi_range(0,100) < State.defence:
		is_defending = true
		$ActionsPanel.hide()
		display_text("you put on the correct PPE.")
		await self.textbox_closed
		await get_tree().create_timer(0.5).timeout
	else:
		display_text("your PPE wasn't cleaned properly...")
		await self.textbox_closed
		await get_tree().create_timer(0.5).timeout
	enemy_turn()

func enemy_turn():
	$ActionsPanel.hide()
	var line = enemy_attack_one_liners.pick_random() % enemy.name
	display_text(line)
	await self.textbox_closed
	
	if is_defending:
		is_defending = false
		$AnimationPlayer.play("player_defending")
		await $AnimationPlayer.animation_finished
		$ActionsPanel.hide()
		display_text("your PPE held.")
		await self.textbox_closed
	else:
		curent_player_health = max(0,curent_player_health - randi_range(enemy.DamageMin, enemy.DamageMax))
		set_health($PlayerPanel/PlayerData/ProgressBar,curent_player_health, State.max_health)
		
		$AnimationPlayer.play("player_damaged")
		await $AnimationPlayer.animation_finished
		
	if curent_player_health == 0:
		$AnimationPlayer.play("player_ded")
		await $AnimationPlayer.animation_finished
		await get_tree().create_timer(1).timeout
		State.current_health = max(1, 0.8* starting_health) 
		SaveLoad.load_player_position(player)
		get_tree().paused = false
		queue_free()
	$ActionsPanel.show()


func _on_attack_pressed() -> void:
	$ActionsPanel.hide()
	display_text("you wipe the surface clean.")
	await self.textbox_closed
	
	current_enemy_health = max(0,current_enemy_health - randi_range(State.MinDamage, State.MaxDamage))
	set_health($enemycontainer/ProgressBar,current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	if current_enemy_health == 0:
		display_text("you defeated %s." % enemy.name)
		await self.textbox_closed
		
		$AnimationPlayer.play("enemy_ded")
		await $AnimationPlayer.animation_finished
		await get_tree().create_timer(0.5).timeout
		State.current_health = curent_player_health
		get_tree().call_group("testbattle", "disable_battle_trigger")
		SaveLoad.Contents_To_Save["playerstats"]["currenthealth"] = State.current_health
		SaveLoad.Contents_To_Save["battles"]["battletest"] = false
		SaveLoad._save()
		get_tree().paused = false
		queue_free()
	
	enemy_turn()

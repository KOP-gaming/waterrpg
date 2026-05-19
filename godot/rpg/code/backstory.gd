extends Control

func _ready() -> void:
	$AnimationPlayer.play("title sequence")
	await  $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/home.tscn")

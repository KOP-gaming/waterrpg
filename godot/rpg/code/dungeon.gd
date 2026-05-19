extends Area2D

func _ready() -> void:
	body_entered.connect(EnterCheck)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func EnterCheck(body) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scenes/dungeon.tscn")

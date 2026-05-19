extends Control
const save_location = "user://SaveFile.json"
@onready var player = get_tree().get_first_node_in_group("player")


func _on_new_game_pressed() -> void:
	if FileAccess.file_exists(save_location):
		DirAccess.remove_absolute(save_location)
		print("Save deleted")
	
	SaveLoad.Contents_To_Save = {
		"scene_positions": {
			"res://scenes/home.tscn": Vector2(117, 13),
			"res://scenes/main_village.tscn": Vector2(394, -115),
			"res://scenes/dungeon.tscn": Vector2(59, 244)
		},
		"battles": {
			"battletest": true
		},
		"playerstats": {
			"currenthealth": 100
		},
		"lastscene": "res://scenes/home.tscn"
	}
	
	get_tree().change_scene_to_file("res://scenes/backstory.tscn")


func _on_resume_pressed() -> void:
	get_tree().change_scene_to_file(SaveLoad.Contents_To_Save["lastscene"])


func _on_quit_pressed() -> void:
	get_tree().quit()

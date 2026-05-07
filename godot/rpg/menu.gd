extends Control
const save_location = "user://SaveFile.json"
@onready var player = get_tree().get_first_node_in_group("player")

func _on_save_pressed() -> void:
	SaveLoad.save_player_position(player)

func _on_load_pressed() -> void:
	SaveLoad.load_player_position(player)

func _on_resume_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_delete_pressed() -> void:
	if FileAccess.file_exists(save_location):
		DirAccess.remove_absolute(save_location)
		print("Save deleted")

extends Node

const save_location = "user://SaveFile.json"

var Contents_To_Save : Dictionary = {
	"scene_positions": {
		"res://scenes/home.tscn": Vector2(117, 13),
		"res://scenes/main_village.tscn": Vector2(394, -115),
		"res://scenes/dungeon.tscn": Vector2(59.0, 244.0)
	},
	"battles":{
		"battletest": true
	},
	"playerstats":{
		"currenthealth": 100
	},
	"lastscene": "res://scenes/home.tscn"
}

func _ready() -> void:
	_load()
	print("SAVE LOADED:", Contents_To_Save)


func save_player_position(player: Node2D):
	var scene_path = get_tree().current_scene.scene_file_path
	
	if Contents_To_Save["scene_positions"].has(scene_path):
		Contents_To_Save["scene_positions"][scene_path] = player.global_position
		Contents_To_Save["lastscene"] = scene_path
		_save()
	else:
		print("Scene not registered in save system:", scene_path)


func _save():
	var file = FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(Contents_To_Save.duplicate())
	file.close()


func load_player_position(player: Node2D):
	var scene_path = get_tree().current_scene.scene_file_path
	
	if Contents_To_Save["scene_positions"].has(scene_path):
		player.global_position = Contents_To_Save["scene_positions"][scene_path]
	else:
		print("No saved position for scene:", scene_path)


func  _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()	
		
		var save_data = data.duplicate()
		
		
		if save_data.has("scene_positions"):
			Contents_To_Save.scene_positions = save_data.scene_positions
		
		if save_data.has("battles"):
			Contents_To_Save.battles = save_data.battles
		
		if save_data.has("playerstats"):
			Contents_To_Save.playerstats = save_data.playerstats
			
			if save_data["playerstats"].has("currenthealth"):
				State.current_health = save_data["playerstats"]["currenthealth"]
		
		if save_data.has("lastscene"):
			Contents_To_Save.lastscene = save_data.lastscene
			
			
		
		

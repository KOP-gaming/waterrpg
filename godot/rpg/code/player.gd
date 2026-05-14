extends CharacterBody2D


const SPEED = 100.0
const SPRINT = 50.0
func _ready() -> void:
	add_to_group("player")
	await get_tree().process_frame
	SaveLoad.load_player_position(self)
	get_position()
	print(position)
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

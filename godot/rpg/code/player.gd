extends CharacterBody2D
var items_in_range = {}

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




func _on_pickup_zone_body_entered(body: Node2D) -> void:
	items_in_range[body] = body
	if items_in_range.size() > 0:
			var pickup_items = items_in_range.values()[0]
			pickup_items.pick_up_item(self)
			items_in_range.erase(pickup_items)


func _on_pickup_zone_body_exited(body: Node2D) -> void:
	if items_in_range .has(body):
		items_in_range.erase(body)

class_name Player
extends CharacterBody3D

@export_group("Nodes")
@export var camera_marker: Marker3D
@export var center_marker: Marker3D
@export var mining_area: Area3D
@export var camera: Camera3D

var health:int = 100
var health_loss_delay = 1.75
var health_loss_timer = 0
const SPEED = 5.0
const JUMP_VELOCITY = 8

func _physics_process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x += direction.x * SPEED / 9
		velocity.z += direction.z * SPEED / 9
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * 4)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta * 4)
	velocity.x = min(abs(velocity.x), 6) * sign(velocity.x)
	velocity.z = min(abs(velocity.z), 6) * sign(velocity.z)
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	var query = PhysicsRayQueryParameters3D.create(from, to,2)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var result := space_state.intersect_ray(query)
	if result:
		center_marker.look_at(result.get("position"))
	move_and_slide()

func _process(delta: float) -> void:
	health_loss_timer += delta
	if health_loss_timer >= health_loss_delay:
		health_loss_timer = 0
		health -= 1
	if Input.is_action_just_pressed("use_item"):
		if Global.get_current_item():
			Global.get_current_item().use_item(self)

func check_mining_area() -> Array[Entity]:
	var entity_array: Array[Entity]
	for thing in mining_area.get_overlapping_bodies():
		if thing is Entity:
			entity_array.append(thing)
	return entity_array

func pickaxe_swing(damage:int):
	var entity_array:Array[Entity] = check_mining_area()
	if damage == 0: return
	for entity in entity_array:
		entity.hurt(damage)

var camera_tween:Tween
func _input(event: InputEvent) -> void:
	#region Camera Control
	if not camera_tween: camera_tween = create_tween()
	if not camera_tween.is_valid():
		if Input.is_action_pressed("cam_left"):
			camera_tween.kill()
			camera_tween = create_tween()
			camera_tween.tween_property(self,"rotation:y",rotation.y + deg_to_rad(45),0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await camera_tween.finished
			camera_tween.kill()
		if Input.is_action_pressed("cam_right"):
			camera_tween.kill()
			camera_tween = create_tween()
			camera_tween.tween_property(self,"rotation:y",rotation.y - deg_to_rad(45),0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await camera_tween.finished
			camera_tween.kill()
	#endregion
	#region Inventory Control
	if Global.get_current_item():
		Global.get_current_item().on_switch_away(self)
	Global.current_item_index += roundi(Input.get_axis("inv_back","inv_forward"))
	if Global.current_item_index < 0:
		Global.current_item_index = 8
	if Global.current_item_index > 8:
		Global.current_item_index = 0
	if Global.get_current_item():
		Global.get_current_item().on_switch_to(self)
	#endregion

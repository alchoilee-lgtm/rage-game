extends CharacterBody2D

@onready var coyote_time = $Coyote_Time
var particles = preload("res://scenes/player particles.tscn")


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _on_spring_area_entered(area: Area2D) -> void:
	velocity.y = -500
func _on_spring_2_area_entered(area: Area2D) -> void:
	velocity.y = -500


func _physics_process(delta: float) -> void:
	var was_on_floor = is_on_floor()
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and (is_on_floor() or !coyote_time.is_stopped()):
		var paticles = particles.instantiate()
		get_parent().add_child(paticles)
		paticles.position = global_position + Vector2(0, 20)
		velocity.y = JUMP_VELOCITY
		coyote_time.stop()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0.2:
			$AnimatedSprite2D.animation = "left"
		if direction > 0.2:
			$AnimatedSprite2D.animation = "right"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	if was_on_floor && not is_on_floor() and velocity.y >= 0:
		coyote_time.start()

func _on_area_2d_area_entered(area: Area2D) -> void:
	modulate.a = 0
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()


func _on_win_detector_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://scenes/win_scene.tscn")

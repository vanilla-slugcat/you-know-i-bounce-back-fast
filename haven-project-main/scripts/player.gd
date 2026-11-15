class_name Player
extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 1200.0      # New: Smoothly increases up to max speed
const AIR_DRAG = 600.0           # A little bit of low friction so momentum carries across bounces
const JUMP_VELOCITY = -900.0
const SLAM_BOUNCE_MULT = 1.25

const SLAM_VELOCITY = 1200
const GRAVITY = 1800

var healthchange = 0

enum state { JUMP, FALL, SLAM, DEAD }

@export var current_state: state = state.JUMP

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurtsfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	Global.hearts = Global.max_hearts
	Hud.update_hearts()

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("press_down") and not is_on_floor() and current_state != state.DEAD:
		change_state(state.SLAM) #can slam at any time

	match current_state:
		state.JUMP:
			apply_gravity(delta)
			horizontal_movement(direction, delta)

			if velocity.y >= 0: #If the player stops going higher, fall
				change_state(state.FALL)
		state.FALL:
			apply_gravity(delta)
			horizontal_movement(direction, delta)

			if is_on_floor():
				bounce()
		state.SLAM:
			velocity.x = 0
			velocity.y = SLAM_VELOCITY
			if is_on_floor():
				bounce(SLAM_BOUNCE_MULT)
			elif is_on_wall(): #If the player slams onto the edge of a wall
				change_state(state.FALL)
		state.DEAD:
			apply_gravity(delta)

	# Save horizontal speed before colliding so we can bounce off walls
	var pre_slide_vx := velocity.x
	move_and_slide()

	if is_on_wall() and current_state != state.SLAM:
		print("bounce off")
		velocity.x = -pre_slide_vx * 0.8

	animate()

func horizontal_movement(direction: float, delta: float) -> void:
	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, AIR_DRAG * delta)

func change_state(new_state: state) -> void:
	if current_state == new_state: return
	current_state = new_state

func apply_gravity(delta: float) -> void:
	if is_on_floor(): return

	var gravity_scale := 1.0

	if current_state != state.DEAD:
		if abs(velocity.y) < 150.0: #lower than a certain velocity
			gravity_scale = 0.6
		elif velocity.y > 0.0: #falling
			gravity_scale = 1.15

	velocity.y += GRAVITY * gravity_scale * delta

func bounce(multiplier: float = 1.0) -> void:
	velocity.y = JUMP_VELOCITY * multiplier
	change_state(state.JUMP)

func animate() -> void:
	match current_state:
		state.JUMP:
			animated_sprite.play("jump")
		state.FALL:
			animated_sprite.play("fall")
		state.SLAM:
			velocity.y = SLAM_VELOCITY
			animated_sprite.play("slam")
		state.DEAD:
			animated_sprite.play("die")

func _on_hit(body: Node2D) -> void:
	take_damage()

func gain_health() -> void:
	Global.hearts  = min(Global.hearts + 1, Global.max_hearts)
	healthchange = 1
	Hud.update_hearts()

func take_damage() -> void:
	if current_state == state.DEAD:
		return

	Global.hearts -= 1
	healthchange = -1
	Hud.update_hearts()
	hurtsfx.play()

	if Global.hearts <= 0:
		die()

func _on_timer_timeout() -> void:
	await Fade.play("fade_out")
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	await Fade.play("fade_in")

func die() -> void:
	change_state(state.DEAD)
	collision_shape_2d.queue_free()
	Engine.time_scale = 0.5
	timer.start()

extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -320.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_double_jump_enabled = false
var is_double_jump_used = false

@onready var game_manager = %GameManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_audio = $JumpAudio
@onready var double_jump_timer = $DoubleJumpTimer


func _ready():
	game_manager.register_player(self)

func _process(delta):
	# Vertical movement
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_double_jump_used = false
	handle_jump()

	# Horizontal movement
	var direction: float = Input.get_axis("move_left", "move_right")
	flip_sprite(direction)
	play_animation(direction)
	apply_movement(direction)
	move_and_slide()


func on_double_jump_enable():
	is_double_jump_enabled = true
	double_jump_timer.start()

func _on_double_jump_timer_timeout():
	is_double_jump_enabled = false


func handle_jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif can_double_jump():
			jump()
			is_double_jump_used = true

func flip_sprite(direction: float):
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
func play_animation(direction: float):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

func apply_movement(direction: float):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func jump():
	velocity.y = JUMP_VELOCITY
	jump_audio.play()

func can_double_jump():
	return is_double_jump_enabled and not is_double_jump_used

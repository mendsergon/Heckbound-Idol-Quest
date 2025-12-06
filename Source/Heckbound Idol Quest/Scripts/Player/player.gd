extends CharacterBody2D

# Reference to the AnimatedSprite2D node
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Movement constants
const SPEED = 150.0
const JUMP_VELOCITY = -350.0

func _physics_process(delta: float) -> void:
	# -----------------------------
	# 1. Apply gravity if not on floor
	# -----------------------------
	if not is_on_floor():
		# get_gravity() returns the current gravity vector
		# Multiply by delta to scale gravity per frame
		velocity += get_gravity() * delta

	# -----------------------------
	# 2. Handle jumping
	# -----------------------------
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# -----------------------------
	# 3. Handle horizontal movement
	# -----------------------------
	var direction := Input.get_axis("left", "right") # -1 for left, 1 for right, 0 for no input

	if direction != 0:
		# Set horizontal velocity based on input
		velocity.x = direction * SPEED
		
		# Play walking animation if on floor
		if is_on_floor() and animated_sprite_2d.animation != "Walk":
			animated_sprite_2d.play("Walk")
		
		# Flip the sprite based on movement direction
		animated_sprite_2d.flip_h = direction < 0
	else:
		# Gradually reduce horizontal velocity when no input
		velocity.x = move_toward(velocity.x, 0, SPEED)

		# Play idle animation if on floor
		if is_on_floor() and animated_sprite_2d.animation != "Idle":
			animated_sprite_2d.play("Idle")

	# -----------------------------
	# 4. Handle animation for jumping/falling
	# -----------------------------
	if not is_on_floor():
		# Play jump animation when in the air
		if animated_sprite_2d.animation != "Jump":
			animated_sprite_2d.play("Jump")

	# -----------------------------
	# 5. Apply movement
	# -----------------------------
	move_and_slide()

extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# --------------------------------------------------------
# Track platform state with simple booleans
# --------------------------------------------------------
var is_enabled: bool = false
var is_switching: bool = false
var switch_timer: Timer
var switch_duration: float = 0.5  # Adjust based on your animation length

# --------------------------------------------------------
# Initialize platform as disabled when entering scene
# --------------------------------------------------------
func _ready() -> void:
	# --------------------------------------------------------
	# Start in disabled state with no collision
	# --------------------------------------------------------
	is_enabled = false
	collision_shape_2d.disabled = true
	animated_sprite_2d.play("Disabled")
	
	# --------------------------------------------------------
	# Create a timer for switching animation completion
	# --------------------------------------------------------
	switch_timer = Timer.new()
	switch_timer.one_shot = true
	switch_timer.timeout.connect(_on_switch_timer_timeout)
	add_child(switch_timer)
	
	print("Platform initialized as DISABLED")

# --------------------------------------------------------
# Public function to enable the platform
# --------------------------------------------------------
func enable() -> void:
	# --------------------------------------------------------
	# Only enable if not already enabled and not switching
	# --------------------------------------------------------
	if !is_enabled and !is_switching:
		_switch_to_enabled()

# --------------------------------------------------------
# Public function to disable the platform
# --------------------------------------------------------
func disable() -> void:
	# --------------------------------------------------------
	# Only disable if currently enabled and not switching
	# --------------------------------------------------------
	if is_enabled and !is_switching:
		_switch_to_disabled()

# --------------------------------------------------------
# Public function to toggle platform between enabled/disabled
# --------------------------------------------------------
func toggle() -> void:
	# --------------------------------------------------------
	# If currently switching, ignore toggle request
	# --------------------------------------------------------
	if is_switching:
		print("Platform is switching, ignoring toggle")
		return
	
	# --------------------------------------------------------
	# Toggle between enabled and disabled states
	# --------------------------------------------------------
	print("=== TOGGLE: Current is_enabled = ", is_enabled, " ===")
	if is_enabled:
		print("Toggling from ENABLED to DISABLED")
		_switch_to_disabled()
	else:
		print("Toggling from DISABLED to ENABLED")
		_switch_to_enabled()

# --------------------------------------------------------
# Switch platform to enabled state with animation
# --------------------------------------------------------
func _switch_to_enabled() -> void:
	# --------------------------------------------------------
	# Set switching flag to prevent multiple animations
	# --------------------------------------------------------
	print("Switching to ENABLED")
	is_switching = true
	is_enabled = true
	
	# --------------------------------------------------------
	# Enable collision immediately (not waiting for animation)
	# --------------------------------------------------------
	collision_shape_2d.disabled = false
	
	# --------------------------------------------------------
	# Play switch animation forward from first frame
	# --------------------------------------------------------
	animated_sprite_2d.speed_scale = 1.0
	animated_sprite_2d.play("Switch")
	animated_sprite_2d.frame = 0
	
	# --------------------------------------------------------
	# Start timer to mark when switching is complete
	# --------------------------------------------------------
	switch_timer.start(switch_duration)

# --------------------------------------------------------
# Switch platform to disabled state with animation
# --------------------------------------------------------
func _switch_to_disabled() -> void:
	# --------------------------------------------------------
	# Set switching flag to prevent multiple animations
	# --------------------------------------------------------
	print("Switching to DISABLED")
	is_switching = true
	is_enabled = false
	
	# --------------------------------------------------------
	# Disable collision immediately (not waiting for animation)
	# --------------------------------------------------------
	collision_shape_2d.disabled = true
	print("DEBUG: Collision disabled set to: ", collision_shape_2d.disabled)
	
	# --------------------------------------------------------
	# Check if animation exists first
	# --------------------------------------------------------
	if not animated_sprite_2d.sprite_frames.has_animation("Switch"):
		print("ERROR: No 'Switch' animation found!")
		is_switching = false
		animated_sprite_2d.play("Disabled")
		return
	
	# --------------------------------------------------------
	# Play the animation in reverse using the correct parameters
	# --------------------------------------------------------
	animated_sprite_2d.play("Switch", -1.0, true)  # Plays backwards from the end
	
	# --------------------------------------------------------
	# Start timer to mark when switching is complete
	# --------------------------------------------------------
	switch_timer.start(switch_duration)
	

# --------------------------------------------------------
# Handle timer completion (more reliable than animation_finished)
# --------------------------------------------------------
func _on_switch_timer_timeout() -> void:
	# --------------------------------------------------------
	# Animation finished, no longer switching
	# --------------------------------------------------------
	print("Switch timer finished. Current state: is_enabled = ", is_enabled)
	is_switching = false
	
	# --------------------------------------------------------
	# Play appropriate idle animation based on current state
	# --------------------------------------------------------
	if is_enabled:
		animated_sprite_2d.play("Enabled")
		print("Platform is now ENABLED")
	else:
		animated_sprite_2d.play("Disabled")
		print("Platform is now DISABLED")
	
	# --------------------------------------------------------
	# Reset speed scale to normal for future animations
	# --------------------------------------------------------
	animated_sprite_2d.speed_scale = 1.0

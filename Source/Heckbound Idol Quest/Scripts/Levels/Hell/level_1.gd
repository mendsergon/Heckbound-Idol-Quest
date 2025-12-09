extends Node2D

@onready var camera_2d: Camera2D = $Camera2D

# Variables
var player: Node2D = null
var max_health: int = 3
var health: int = max_health

# Signals
signal died

func _ready() -> void:
	# --------------------------------------------------------
	# Wait a moment for player to be spawned by Main.gd
	# --------------------------------------------------------
	await get_tree().process_frame
	await get_tree().process_frame  # Wait 2 frames to be sure
	
	# --------------------------------------------------------
	# Find the player that was spawned into this level
	# --------------------------------------------------------
	find_player_and_attach_camera()


func find_player_and_attach_camera():
	# --------------------------------------------------------
	# 1. Look for player in the scene tree
	# --------------------------------------------------------
	# The player is spawned into the World node, which is our parent
	var world = get_parent()
	if world:
		# Search through world's children for player
		for child in world.get_children():
			# Check if this is likely the player 
			if "Player" in child.name or "player" in child.name.to_lower():
				player = child
				print("Found player in level: ", player.name)
				break
	
	# --------------------------------------------------------
	# 2. If found, attach camera to player
	# --------------------------------------------------------
	if player:
		# Remove camera from level scene
		remove_child(camera_2d)
		
		# Add camera as child of player
		player.add_child(camera_2d)
		
		# Reset camera position relative to player (center on them)
		camera_2d.position = Vector2.ZERO
		
		# Make this camera active
		camera_2d.make_current()
		
		print("Camera attached to player")
	else:
		print("ERROR: Could not find player in level!")
		# Keep camera as-is in level (static camera)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		health = 0
		emit_signal("died") # Tell main the player is dead

func _process(delta: float) -> void:
	pass

extends Node2D

@onready var camera_2d: Camera2D = $Camera2D

# Variables
var player: Node2D = null

var initial_camera_y: float = 0.0  # Store initial camera Y position



func _ready() -> void:
	# --------------------------------------------------------
	# Wait a moment for player to be spawned by Main.gd
	# --------------------------------------------------------
	await get_tree().process_frame
	await get_tree().process_frame  # Wait 2 frames to be sure
	
	# --------------------------------------------------------
	# Store initial camera Y position
	# --------------------------------------------------------
	initial_camera_y = camera_2d.global_position.y
	
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
	# 2. If found, make camera active
	# --------------------------------------------------------
	if player:
		# Make this camera active
		camera_2d.make_current()
		
		print("Camera following player horizontally")
	else:
		print("ERROR: Could not find player in level!")
		# Keep camera as-is in level (static camera)

func _process(delta: float) -> void:
	# --------------------------------------------------------
	# Update camera position to follow player horizontally only
	# --------------------------------------------------------
	if player:
		var player_pos = player.global_position
		var camera_pos = camera_2d.global_position
		
		# Update only X position, keep Y at initial position
		camera_2d.global_position = Vector2(player_pos.x, initial_camera_y)

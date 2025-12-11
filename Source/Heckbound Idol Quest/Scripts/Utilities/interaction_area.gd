extends Area2D

# --------------------------------------------------------
# Signal emitted when player interacts with this area
# --------------------------------------------------------
signal interacted

# --------------------------------------------------------
# Text displayed in label describing interaction action
# --------------------------------------------------------
@export var action_name: String = "interact"

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

# --------------------------------------------------------
# State tracking variables
# --------------------------------------------------------
var player_inside: bool = false
var can_interact: bool = true
var has_interacted: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# --------------------------------------------------------
	# Initialize label visibility and connect body signals
	# --------------------------------------------------------
	label.visible = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))


func _on_body_entered(body: Node) -> void:
	# --------------------------------------------------------
	# Handle player entering interaction area
	# --------------------------------------------------------
	if body.is_in_group("player"):
		player_inside = true
		label.visible = true
		update_label_position()


func _on_body_exited(body: Node) -> void:
	# --------------------------------------------------------
	# Handle player exiting interaction area
	# --------------------------------------------------------
	if body.is_in_group("player"):
		player_inside = false
		label.visible = false


func _process(_delta: float) -> void:
	# --------------------------------------------------------
	# Update label position while player is inside area
	# --------------------------------------------------------
	if player_inside:
		update_label_position()


func update_label_position() -> void:
	# --------------------------------------------------------
	# Position label above interaction area
	# --------------------------------------------------------
	label.position = Vector2(-30, -40)


func _input(event: InputEvent) -> void:
	# --------------------------------------------------------
	# Handle interaction input and emit signal when pressed
	# --------------------------------------------------------
	if player_inside and can_interact and event.is_action_pressed("Interact"):
		can_interact = false
		label.visible = false
		emit_signal("interacted")
		has_interacted = true
		
		# --------------------------------------------------------
		# Reset interaction after 1 second instead of requiring exit
		# --------------------------------------------------------
		await get_tree().create_timer(1.0).timeout
		can_interact = true
		has_interacted = false
		
		# --------------------------------------------------------
		# Show label again if player is still inside area
		# --------------------------------------------------------
		if player_inside:
			label.visible = true

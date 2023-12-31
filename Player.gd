extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var death_height = 1000
@onready var respawn_pos = get_parent().get_node("Respawn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimationPlayer.current_animation = "Idle"

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction == -1:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		$AnimationPlayer.current_animation = "Run"
		velocity.x = direction * SPEED
	else:
		$AnimationPlayer.current_animation = "Idle"
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if position.y > death_height:
		position = respawn_pos.position
	move_and_slide()

extends CharacterBody2D

@export var speed = 200
@export var jump_velocity = -500
@export var gravity = 1200

func _physics_process(delta):
	var velocity = self.velocity

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jumping
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_velocity

	# Movement
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = direction * speed

	# Flip sprite
	if direction != 0:
		$AnimatedSprite2D.flip_h = direction < 0

	# Crouching
	var is_crouching = Input.is_action_pressed("move_down") and is_on_floor()

	# Animations
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif is_crouching:
		$AnimatedSprite2D.play("crouch")
	else:
		if direction != 0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")

	# Switch hitboxes (make sure nodes exist!)
	$Collision_Stand.disabled = is_crouching
	$Collision_Crouch.disabled = not is_crouching

	# Apply movement
	self.velocity = velocity
	move_and_slide()

extends CharacterBody2D

var screen_size

signal hit

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
		$AnimatedSprite2D.play()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

	var collision = move_and_collide(velocity * delta)
	
	if collision:
		_kill_player()
	
	position = position.clamp(Vector2.ZERO, screen_size)

func _kill_player() -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false

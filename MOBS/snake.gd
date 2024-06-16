extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gold = preload ("res://Collectibles/money.tscn")
var chase = false
var speed = 100
@onready var anim = $Snake_Animation
var alive = true
var player
var direction
@onready var sprite = $Snake_Animation

func ready():
	Signals.connect("player_position_update", Callable (self, "_on_player_position_update"))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if alive == true:
		if chase == true:
			direction = (player - self.position).normalized()
			velocity.x = direction.x * speed
			anim.play("Run")
		else:
			velocity.x = 0
			anim.play("Idle")
		if direction.x < 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		move_and_slide()	

func _on_player_position_update (player_pos):
	player = player_pos
	

func _on_detector_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_detector_body_exited(body):
	if body.name == "Player":
		body.velocity.y -=200
		chase = false

func _on_death_body_entered(body):
	if body.name == "Player":
		body.velocity.y -=200
		death()

func _on_damage_body_entered(body):
	if body.name == "Player":
		if alive ==true:
			body.health -=15

func death():
	alive = false
	anim.play("Death")
	await anim.animation_finished
	var _goldTemp = gold.instantiate()
	
	queue_free()





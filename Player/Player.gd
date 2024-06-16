extends CharacterBody2D

enum{
	MOVE,
	ATTACK,
	DAMAGE,
	DEATH
}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var player_pos
var state = MOVE
var attack_cooldown = false

func _ready():
	Signals.connect("enemy_attack", Callable (self, "_on_damage_received"))

func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		DAMAGE:
			damage_state()
		DEATH:
			death_state()
			get_tree().change_scene_to_file("res://UI/Death menu/Death_menu.tscn")
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("attack") and attack_cooldown == false:
		state = ATTACK
		
	move_and_slide()
	
	player_pos = self.position
	Signals.emit_signal("player_position_update", player_pos)

func _on_timer_timeout():
	$Timer.wait_time=Global.regen_speed
	if Global.player_health < Global.max_player_health:
		Global.player_health += Global.health_regen

func move_state ():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)	
		if velocity.y == 0:
			animPlayer.play("Idle")
	if direction == -1:
		anim.flip_h = true
		$AttackDirection.rotation_degrees = 0
	elif direction == 1:
		anim.flip_h = false
		$AttackDirection.rotation_degrees = 200

func attack_state ():
	velocity.x = 0
	animPlayer.play ("Attack")
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE

func death_state():
	velocity.x=0
	anim.play("Death")
	await anim.animation_finished

func attack_freeze():
	attack_cooldown = true
	await get_tree().create_timer(0.3).timeout
	attack_cooldown = false

func damage_state ():
	state = MOVE

func _on_hit_box_area_entered(_area):
	Signals.emit_signal("player_attack", Global.damage)

func _on_damage_received (enemy_damage):
	Global.player_health -= enemy_damage
	if Global.player_health <= 0:
		Global.player_health=0
		state=DEATH
	else:
		state = DAMAGE


extends CharacterBody2D

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $Deceased_Animation

enum {
	IDLE,
	CHASE,
	ATTACK,
	DAMAGE,
	DEATH
}
var state: int = 0:
	set(value):
		state=value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			DAMAGE:
				damage_state()
			DEATH:
				velocity.x = 0
				Signals.emit_signal("enemy_died", position)
				death_state()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player = Vector2.ZERO
var direction = Vector2.ZERO
var damage = 20
var move_speed = 150

func _ready():
	state = CHASE
	Signals.connect("player_position_update", Callable (self, "_on_player_position_update"))
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	match state:
		IDLE:
			pass
		CHASE:
			pass
		ATTACK:
			pass
	if state == CHASE:
		chase_state()
	move_and_slide()

func _on_player_position_update(player_pos):
	player = player_pos

func _on_attack_range_body_entered(_body):
	state = ATTACK

func idle_state():
	velocity.x = 0
	animPlayer.play("Idle")
	await get_tree().create_timer(2).timeout
	$AttackDirection/AttackRange/CollisionShape2D.disabled = false
	state = CHASE

func attack_state():
	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	$AttackDirection/AttackRange/CollisionShape2D.disabled = true
	state = IDLE

func chase_state():
	animPlayer.play("Run")
	direction = (player - self.position).normalized()
	if direction.x<0:
		sprite.flip_h=false
		$AttackDirection.scale=Vector2(-1,1)
	else:
		sprite.flip_h=true
		$AttackDirection.scale=Vector2(1,1)
	velocity.x = direction.x * move_speed
func damage_state():
	velocity.x = 0
	animPlayer.play("Hurt")
	await animPlayer.animation_finished
	state = IDLE
	
func death_state():
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()

func _on_hit_box_area_entered(_area):
	Signals.emit_signal("enemy_attack", damage)

func _on_mob_health_no_health():
	state = DEATH

func _on_mob_health_damage_received():
	velocity.x = 0
	state = IDLE
	state = DAMAGE

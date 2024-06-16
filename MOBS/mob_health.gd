extends Node2D

signal no_health()
signal damage_received ()

@onready var health_bar = $HealthBar
@onready var damage_text = $DamageText
@onready var animPlayer = $AnimationPlayer
var player_dmg

var mobhealth = 100:
	set (value):
		mobhealth = value
		health_bar.value = mobhealth
		if mobhealth <= 0:
			health_bar.visible = false
		else:
			health_bar.visible = true

func _ready ():
	Signals.connect("player_attack", Callable (self, "_on_damage_received"))
	health_bar.max_value = mobhealth
	health_bar.visible = false

func _on_damage_received(player_damage):
	player_dmg = player_damage



func _on_hurt_box_area_entered(_area):
	await get_tree().create_timer(0.1).timeout
	mobhealth -= player_dmg
	damage_text.text = str (player_dmg)
	animPlayer.play("damage_text")
	if  mobhealth <= 0:
		emit_signal("no_health")
	else:
		emit_signal("damage_received")

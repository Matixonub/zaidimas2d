extends Node2D
@onready var light = $DirectionalLight2D
@onready var days = $CanvasLayer/Days
var deceased_preload = preload("res://MOBS/deceased.tscn")

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
	}

func _ready():
	Global.player_health =100
	Global.player_gold = 0
	Global.player_kills = 0
	Global.day_count = 0
	set_day_text()
	light.enabled = true
	
var state = MORNING

func set_day_text ():
	days.text = "DAY " + str(Global.day_count)

func morning_state ():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.2, 20)
func evening_state ():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.95, 20)

func _on_day_night_timeout():
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	if state < 3:
		@warning_ignore("int_as_enum_without_cast")
		state +=1
	else:
		state = MORNING
		Global.day_count +=1
		set_day_text()


func _on_spawner_timeout():
	deceased_spawn()

func deceased_spawn ():
	var deceased = deceased_preload.instantiate()
	deceased.position = Vector2(randi_range(50, 2250), 600)
	$MOBS.add_child(deceased)


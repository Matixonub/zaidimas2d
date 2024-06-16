extends ParallaxBackground

var background_speed = 50

func _process(delta):
	scroll_offset.x -=background_speed * delta

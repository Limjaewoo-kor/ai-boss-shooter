extends Area2D

const SPEED = 250

func _physics_process(delta):
	position.y += SPEED * delta
	if position.y > 800:
		queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()

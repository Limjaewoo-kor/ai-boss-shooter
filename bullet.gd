extends Area2D

const SPEED = 400

func _physics_process(delta):
	position.y -= SPEED * delta
	if position.y < -20:
		queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()

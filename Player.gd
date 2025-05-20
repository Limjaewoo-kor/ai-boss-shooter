extends CharacterBody2D

@export var bullet_scene: PackedScene  # 에디터에서 bullet.tscn 연결

const SPEED = 300.0

var move_log = []
var shoot_times = []

const LOG_LIMIT = 30  # 최대 30개까지 저장

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	velocity = input_vector * SPEED
	move_and_slide()
	
	# 이동 방향 기록 (프레임마다 하면 너무 많으므로 delta 누적 추천)
	if input_vector.length() > 0:
		var dir = ""
		if input_vector.x > 0:
			dir = "RIGHT"
		elif input_vector.x < 0:
			dir = "LEFT"
		elif input_vector.y > 0:
			dir = "DOWN"
		elif input_vector.y < 0:
			dir = "UP"

		move_log.append(dir)
		if move_log.size() > LOG_LIMIT:
			move_log.pop_front()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if bullet_scene:
			var bullet = bullet_scene.instantiate()
			bullet.position = position - Vector2(0, 20)
			get_parent().add_child(bullet)
			shoot_times.append(Time.get_ticks_msec())
			if shoot_times.size() > LOG_LIMIT:
				shoot_times.pop_front()



var max_hp = 5
var hp = max_hp

@onready var health_bar = $HealthBar  # 아래 단계에서 만들 예정

func take_damage():
	hp -= 1
	update_health_bar()
	print("플레이어 HP:", hp)

	if hp <= 0:
		die()

func update_health_bar():
	if health_bar:
		health_bar.value = hp
		health_bar.max_value = max_hp

func die():
	print("💀 플레이어 사망!")
	queue_free()
	# 또는 게임오버 씬 전환 / 리스타트 처리

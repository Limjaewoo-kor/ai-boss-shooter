extends CharacterBody2D

@onready var health_bar = $HealthBar
var max_hp = 10
var hp = max_hp

var move_speed = 100
var move_direction = 1  # 1 = 오른쪽, -1 = 왼쪽
var move_range = Vector2(100, 1000)  # 이동 가능한 X 좌표 범위

func _physics_process(delta):
	position.x += move_direction * move_speed * delta

	if position.x > move_range.y:
		position.x = move_range.y
		move_direction = -1
	elif position.x < move_range.x:
		position.x = move_range.x
		move_direction = 1


func take_damage():
	hp -= 1
	update_health_bar()
	if hp <= 0:
		queue_free()

func update_health_bar():
	if health_bar:
		health_bar.value = hp
		health_bar.max_value = max_hp




@onready var player = null
var phase = 1  # 초기 상태
@export var boss_bullet_scene: PackedScene

@onready var attack_timer = Timer.new()

func _ready():
	update_health_bar()
	player = get_node("/root/Main/Player")  # 경로는 상황에 맞게 수정
	$Timer.start()
	add_child(attack_timer)
	attack_timer.wait_time = 1.5
	attack_timer.timeout.connect(fire_bullet)
	attack_timer.start()


func fire_bullet():
	if boss_bullet_scene:
		var bullet = boss_bullet_scene.instantiate()
		bullet.position = position + Vector2(0, 30)
		get_parent().add_child(bullet)

		if phase >= 2:
			var bullet2 = boss_bullet_scene.instantiate()
			bullet2.position = position + Vector2(20, 30)
			get_parent().add_child(bullet2)


func check_pattern():
	#print("check_pattern 호출됨")
	var repeated = false
	if player.move_log.size() >= 10:
		var last = player.move_log[-1]
		var count = 0
		for i in player.move_log:
			if i == last:
				count += 1
		if count >= 8:
			repeated = true

	if repeated and phase == 1:
		print("플레이어 패턴 감지! 보스 페이즈 전환")
		phase = 2
		start_phase_2()

func start_phase_2():
	# 보스가 더 빠르게 움직이거나, 공격 방식 바뀌거나
	modulate = Color(1, 0.5, 0.5)  # 보스를 붉게
	move_speed = 200  # 이동 속도 증가
	# 나중에 공격 방식/스킬 교체 등 추가 가능


func _on_timer_timeout():
	check_pattern()




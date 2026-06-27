extends Area2D

@export var bullet_speed : float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3).timeout #3s后
	queue_free() #摧毁
#思考 为什么要用get_tree().create_timer(3).timeout，这是什么意思


func _physics_process(delta: float) -> void:
	# 将子弹按匀速水平移动。
	# bullet_speed 的单位为像素/秒，正值向右移动，负值向左。
	# 乘以 delta 使得移动与帧率脱钩，在不同设备上表现一致。
	position += Vector2(bullet_speed,0) * delta

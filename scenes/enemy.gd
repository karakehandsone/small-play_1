extends Area2D

## 史莱姆在水平方向上的默认移动速度（像素/秒）。
## 负值：向左移动；正值：向右移动；0：静止。
## 该值会在 _ready() 中传递给 move_direction，修改时可改变初始行为。
@export var slime_speed : float = -100


## 根据 slime_speed 水平移动该角色，每物理帧自动执行。
## 移动为匀速直线运动，乘以 delta 保证在不同帧率下速度一致。
## slime_speed 的单位为像素/秒，负值向左，正值向右。
func _physics_process(delta: float) -> void:
	# 计算本帧的水平位移并累加到 position 上
	# 每物理帧根据 slime_speed（像素/秒）水平移动，乘以 delta 确保帧率稳定
	position += Vector2(slime_speed,0) * delta
	
	


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.game_over()

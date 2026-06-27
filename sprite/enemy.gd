extends Area2D

## 史莱姆在水平方向上的默认移动速度（像素/秒）。
## 负值：向左移动；正值：向右移动；0：静止。
## 该值会在 _ready() 中传递给 move_direction，修改时可改变初始行为。
@export var slime_speed : float = -100
var is_dead : bool = false

## 根据 slime_speed 水平移动该角色，每物理帧自动执行。
## 移动为匀速直线运动，乘以 delta 保证在不同帧率下速度一致。
## slime_speed 的单位为像素/秒，负值向左，正值向右。
func _physics_process(delta: float) -> void:
	if not is_dead:
		

		
	# 计算本帧的水平位移并累加到 position 上
	# 每物理帧根据 slime_speed（像素/秒）水平移动，乘以 delta 确保帧率稳定
		position += Vector2(slime_speed,0) * delta
	if position.x< -267:
		queue_free()
	
	


func _on_body_entered(body: Node2D) -> void:
	# 检查进入的物体是否为玩家角色（CharacterBody2D）
	if body is CharacterBody2D:
		# 调用玩家的 game_over 方法，执行游戏结束流程
		body.game_over()
		 
# 当另一个 Area2D 进入时调用，用于处理被子弹击中的逻辑。
# 如果进入的区域属于 "bullet" 组，则表示该角色被子弹击中，
# 随后播放死亡动画、标记死亡状态并销毁子弹。
func _on_area_entered(area: Area2D) -> void:
	# 检查进入的区域是否属于 "bullet" 组，防止其他区域误触发
	if area.is_in_group("bullet"):
		# 播放死亡动画
		$AnimatedSprite2D.play("death")
		# 将角色标记为已死亡，可用于禁用移动等其他逻辑
		is_dead = true
		# 销毁子弹区域节点，避免重复命中
		area.queue_free()
		get_tree().current_scene.score += 1
		
		await  get_tree().create_timer(0.6).timeout
		queue_free()

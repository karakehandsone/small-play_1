extends CharacterBody2D

#给老子记住，bool 变量：ture或者false
#给 is_game_over 赋值 游戏结束
var is_game_over : bool = false


@export var move_speed : float = 50 #速度函数为float并赋值为50  
@export var animator : AnimatedSprite2D #把一个东西命名并固定在右边菜单上

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:	#这玩意是固定成60fps，好像挺牛逼的
	#如果没有 游戏结束
	if not is_game_over:
		
		#上面的 以尽可能最佳的方式将一个或多个任意类型的参数转换为字符串，并将其打印到控制台。
		#print(Input.get_vector("left","rigeht","up","down"))
		
		# 将玩家输入转换为移动速度。
		# Input.get_vector() 返回一个归一化方向向量（基于左右上下动作状态），
		# 乘以 move_speed 后得到最终的速度（像素/秒），供 move_and_slide() 使用。
		velocity = Input.get_vector("left","right","up","down") * move_speed
		
		#如果速度为0
		#待机动画
		if velocity == Vector2.ZERO:
			animator.play("idle")
			
		#否则就奔跑 
		else:
			animator.play("run")
			
		# 执行移动，让角色在物理世界中实际位移，并自动处理碰撞滑动
		move_and_slide()
 
## 执行游戏结束流程：标记状态、播放死亡动画、等待后重载场景。
func game_over():
	# 将游戏结束标志设为 true（可用于禁用输入等）
	is_game_over = true
	# 播放角色死亡动画
	animator.play("die")
	# 等待 3 秒，让死亡动画充分展示，然后重新加载当前场景
	await get_tree().create_timer(3).timeout
	# 重新加载当前场景（等同于关卡重置）
	get_tree().reload_current_scene()

extends CharacterBody2D

#给老子记住，bool 变量：ture或者false
#给 is_game_over 赋值 游戏结束
var is_game_over : bool = false
@export var move_speed : float = 50 #速度函数为float并赋值为50  
@export var animator : AnimatedSprite2D #把一个东西命名并固定在右边菜单上
@export var bullet_scene : PackedScene
@export var roll_speed : float = 150
@export var roll_duration : float = 0.3
var is_rolling : bool = false
var roll_timer : float = 0.0
var roll_dir : Vector2 = Vector2.ZERO
		

func _process(_delta: float) -> void:
	if velocity == Vector2.ZERO or is_game_over:
		$Node2D/runningsound.stop()
	elif not $Node2D/runningsound.playing:
		$Node2D/runningsound.play()			

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta: float) -> void:	#这玩意是固定成60fps，好像挺牛逼的
	#如果没有 游戏结束
	if not is_game_over:
		
		#上面的 以尽可能最佳的方式将一个或多个任意类型的参数转换为字符串，并将其打印到控制台。
		#print(Input.get_vector("left","rigeht","up","down"))
		
		# 将玩家输入转换为移动速度。
		# Input.get_vector() 返回一个归一化方向向量（基于左右上下动作状态），
		# 乘以 move_speed 后得到最终的速度（像素/秒），供 move_and_slide() 使用。
		
		## 原版本：velocity = Input.get_vector("left","right","up","down") * move_speed
		#现版本：将后面的存入input——dir，防止避免重复调用并且保留“方向”用于“翻滚”
		var input_dir = Input.get_vector("left","right","up","down")
		if is_rolling:
			# 持续翻滚：按固定方向移动，并倒计时
			roll_timer -= _delta
			if roll_timer <= 0:
				is_rolling = false
			velocity = roll_dir * roll_speed
			$AnimatedSprite2D.play("roll")	
		else:
			# 正常移动
			velocity = input_dir * move_speed
			# 检测翻滚触发（需要存在移动方向）
			if Input.is_action_just_pressed("roll") and input_dir.x != 0:
				is_rolling = true
				roll_timer = roll_duration
				roll_dir = Vector2(sign(input_dir.x), 0)   # 左或右，绝无上下
					
				#roll_dir = input_dir          # 翻滚方向 = 当前输入方向(舍不得删）
			if velocity == Vector2.ZERO:
				$AnimatedSprite2D.play("idle")
			else:
				$AnimatedSprite2D.play("run")   # 翻滚时也可以播放 run，或者改成 "roll" 动画
		move_and_slide()
		
		##废弃，舍不得删	
		#如果速度为0
		#待机动画
		#if velocity == Vector2.ZERO:
			#$AnimatedSprite2D.play("idle")
			
		#否则就奔跑 
		#else:
			#$AnimatedSprite2D.play("run")
			
		# 执行移动，让角色在物理世界中实际位移，并自动处理碰撞滑动
		#move_and_slide()
 
## 执行游戏结束流程：标记状态、播放死亡动画、等待后重载场景。
func game_over():
	if not is_game_over:
		# 将游戏结束标志设为 true（可用于禁用输入等）
		is_game_over = true
		# 播放角色死亡动画
		animator.play("die")
		
		get_tree().current_scene.show_game_over()
		
		$Node2D/gameover_sound.play()
		
		#3s后重启游戏
		$resterTimer2.start()		
		##废案
		# 等待 3 秒，让死亡动画充分展示，然后重新加载当前场景
		#await get_tree().create_timer(3).timeout
		# 重新加载当前场景（等同于关卡重置）
		#get_tree().reload_current_scene()


func _on_fire() -> void:
	if velocity != Vector2.ZERO or is_game_over: # 如果速度不等于0
		return #中断代码
		
	$Node2D/firesound.play()
		 
	#这一行代码：通过加载打包好的场景资源（PackedScene），调用 instantiate() 方法生成该场景的实例。
	#声明【子弹节点】是调用【子弹场景】
	var bullet_node = bullet_scene.instantiate()
	bullet_node.position = position + Vector2(17,7) #position = 位置
	#第3行是在当前场景生成【子弹节点】
	get_tree().current_scene.add_child(bullet_node)


func _reload_scene() -> void:
	get_tree().reload_current_scene()  

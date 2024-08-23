extends Control

@export var border = 5

@onready var attacks = $Attacks
@onready var shapes = $Collisions

func _ready():
	#resize(Vector2(100,100), 0)
	pass

func _process(delta):
	update_size()

func update_size():
	shapes.get_child(0).position.x = -100 + border
	shapes.get_child(1).position.y = -100 + border
	shapes.get_child(2).position.y = self.size.y + 100 - border
	shapes.get_child(3).position.x = self.size.x + 100 - border

func resize(dimension : Vector2, newpos = null, top = 1, bot = 1, time = 1.5):
	var pos_tween = get_tree().create_tween()
	var resize_tween = get_tree().create_tween()
	resize_tween.tween_property(
		self,
		":size:y",
		dimension.y,
		time,
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		
		
	resize_tween.tween_property(
		self,
		":size:x",
		dimension.x,
		time,
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	match top:
		0:
			pass
		1:
			resize_tween.tween_property(
				self,
				":position:y",
				self.position.y + ((size.y - dimension.y)/2.0),
				time,
				).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		2:
			resize_tween.tween_property(
				self,
				":position:y",
				self.position.y + ((size.y - dimension.y)),
				time,
				).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	match bot:
		0:
			pass
		1:
			resize_tween.tween_property(
				self,
				":position:x",
				self.position.x + ((size.x - dimension.x)/2.0),
				time,
				).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		2:
			resize_tween.tween_property(
				self,
				":position:x",
				self.position.x + ((size.x - dimension.x)),
				time,
				).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	# resize_tween.start()
	if newpos != null:
		pos_tween.tween_property(
			self,
			":position",
			newpos,
			time + 0.1,
			).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		# pos_tween.start()

func move(newpos : Vector2, time = 1.0):
	var pos_tween = get_tree().create_tween()
	pos_tween.tween_property(
		self,
		":position",
		newpos,
		time,
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	# pos_tween.start()

func add_attack(node):
	attacks.add_child(node)
	print(node.global_position)

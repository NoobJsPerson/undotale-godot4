extends Node2D

@onready var Attacker = preload("res://BattleEngine/DamageMeter/DamageMeter.tscn")
@onready var Slice = preload("res://BattleEngine/Weapon/Weapon.tscn")
@onready var Damage = preload("res://BattleEngine/DamageMeter/Text/Damage.tscn")

@onready var box = $Box
@onready var global_attacks = $Attacks
@onready var attacks = $Box/Attacks
@onready var blitter = $Box/Blitter
@onready var enemies = $Enemies
@onready var soul = $Soul

@onready var buttons = $Buttons
@onready var acting = $ActingSelector
@onready var items = $ItemSelector

var selection
var function

signal shake_camera

func _ready():
	shake_camera.connect(_on_shake_camera) # connect("shake_camera", Callable(self, "shake_camera"))
	$Music.play(10)
	$HUD/Name.text = Data.human
	playersTurn()

func _process(delta):
	pass

func playersTurn(reset_line = true):
	if reset_line:
		blitter.feed(["* You feel puzzled.", [22], null, false])
	buttons.enable(soul)
	await buttons.select
	#blitter.feed(["", null, null, true])
	
	function = buttons.get_selection()
	match function:
		"Fight", "Act", "Mercy":
			target()
		"Item":
			if Data.items.is_empty():
				playersTurn(false)
				return
			items.enable(soul, blitter)
			await items.select
			if items.enabled:
				items.enabled = false
				playersTurn()
				return

func target():
	enemies.enable(soul)
	blitter.feed([enemies.string(), null, null, true])
	await enemies.select
	selection = enemies.get_selection()
	
	if enemies.enabled:
		enemies.enabled = false
		playersTurn()
		return
	
	match function:
		"Fight":
			buttons.turn_off()
			soul.position = Vector2(-10,-10)
			
			var attacker = Attacker.instantiate()
			attacker.position = box.position + (box.size / 2)
			attacker.connect("slaughter", Callable(self, "slay"))
			attacker.connect("enemys_turn", Callable(self, "enemysTurn"))
			
			blitter.feed()
			
			add_child(attacker)
			
			print(attacker.rotation)
		"Act":
			acting.list = selection.actings
			blitter.feed([acting.string(), null, null, true])
			acting.enable(soul)
			await acting.select
			
			if acting.enabled:
				acting.enabled = false
				target()
				return
			
			buttons.turn_off()
			var get_act_string = selection.acting(acting.selection)
			
		"Mercy":
			buttons.turn_off()
			if selection.spareable:
				selection.spare()
			blitter.feed(["", null, null, true])
			enemysTurn()

func slay():
	var slice = Slice.instantiate()
	slice.position = selection.position
	add_child(slice)
	await get_tree().create_timer(1).timeout
	
	var damage = Damage.instantiate()
	damage.position = selection.position
	selection.shake(15)
	damage.get_node("Label").text = str(selection.DEF)
	
	add_child(damage)
	
	print(damage.rotation)

func enemysTurn():
	enemies.cutscene(box)
	await enemies.cutscene_end
	
	enemies.attack()
	await enemies.cutscene_end
	
	soul.changeMovement("")
	playersTurn()

var store_amnt = 0
var random = [-1, 1]

func _on_shake_camera(amount = 5):
	if store_amnt == 0:
		store_amnt = (amount/100.0) + 0.01
	var offset_sign = Vector2((int($Camera3D.offset.x >= 0) * 2) - 1,(int($Camera3D.offset.y >= 0) * 2) - 1)
	$Camera3D.offset = Vector2 (-(amount * offset_sign.x),random[randi() % random.size()] * (amount * offset_sign.y))
	amount -= 1
	var test = amount/100.0
	await get_tree().create_timer(store_amnt - test).timeout
	if amount != 0:
		_on_shake_camera(amount) # ether: idk if this is calling the signal or the function itself
	else:
		store_amnt = 0

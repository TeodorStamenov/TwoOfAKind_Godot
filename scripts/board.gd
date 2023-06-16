extends Control

signal match_pairs_signal

var first_card = null
var second_card = null


# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_cards()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventMouseButton:
		if first_card != null and second_card != null:
			event.pressed = false
	pass


func _setup_cards():
	var Card = preload("res://scenes/card.tscn")
	var card_instance = Card.instantiate()
	
	var all_indexes = range(1,20)
	all_indexes.shuffle()
	
	var indexes = all_indexes.slice(0, 6)
	indexes.append_array(indexes.duplicate())
	indexes.shuffle()
	
	for idx in indexes:
		var card = card_instance.duplicate() as Card
		$Cards.add_child(card)
		card.face.set_texture(load("res://assets/landscapes/index" + str(idx) + ".jpg"))
		card.index = idx
		card.flip_started_signal.connect(_on_card_flip_started)
		card.flip_finish_signal.connect(_on_card_flip_finish)
	pass # Replace with function body.
	

func _on_card_flip_started(card):
	if first_card == null:
		first_card = card
	elif second_card == null:
		second_card = card
	pass


func _on_card_flip_finish():
	if first_card != null and second_card != null:
		$HoldCardsOpen.start()
	pass


func _on_hold_cards_open_timeout():
	if first_card.index == second_card.index:
		emit_signal("match_pairs_signal")
	else:
		first_card.flipAnimation.play("hide")
		second_card.flipAnimation.play("hide")
		reset_cards()
	pass

func start_cards_vanish():
	first_card.flipAnimation.play("vanish")
	second_card.flipAnimation.play("vanish")
	pass
	

func start_cards_explosion():
	first_card.start_explosion()
	second_card.start_explosion()
	pass

func reset_cards():
	first_card = null
	second_card = null

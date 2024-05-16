extends Node

var player = null
var powerups = []
var score = 0

@onready var score_label = $ScoreLabel

func register_player(player_instance):
    print("Registering player")
    player = player_instance
    for powerup in powerups:
        connect_powerup_to_player(powerup)

func register_powerup(powerup_instance):
    print("Registering powerup")
    powerups.append(powerup_instance)
    if player:
        connect_powerup_to_player(powerup_instance)

func connect_powerup_to_player(powerup):
    powerup.collected.connect(player.on_double_jump_enable)

func add_point():
    score += 1
    score_label.text = "You collected " + str(score) + " coins!"

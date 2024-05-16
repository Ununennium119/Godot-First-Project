extends Area2D

signal collected

@onready var game_manager := %GameManager

func _ready():
	game_manager.register_powerup(self)

func _on_body_entered(_body):
	collected.emit()
	queue_free()

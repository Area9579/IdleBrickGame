extends Control

@export var basicBallR: Ball
@onready var basicBall = self
@export var gameManR: GameManager
@onready var gameMan = $"../../../../../../GameManager"

@onready var powerLabel = (basicBall.get_child(2)).get_child(0)
@onready var speedLabel = (basicBall.get_child(3)).get_child(0)
@onready var plusLabel = (basicBall.get_child(1)).get_child(0)

# Base costs for each upgrade
var base_cost_power: int = 5
var base_cost_speed: int = 3
var base_cost_ball: int = 10

# Upgrade counters
var power_upgrades: int = 1
var speed_upgrades: int = 1
var ball_upgrades: int = 1

func _ready() -> void:
	set_text(powerLabel, power_upgrades, calculate_cost(base_cost_power, power_upgrades))
	set_text(speedLabel, speed_upgrades, calculate_cost(base_cost_speed, speed_upgrades))
	set_text(plusLabel, ball_upgrades, calculate_cost(base_cost_ball, ball_upgrades))

func calculate_cost(base_cost: int, upgrades: int) -> int:
	return int(base_cost * (upgrades + 1) * log(upgrades + 2))

func set_text(label: Label, upgrades: int, cost: int):
	label.text = "Cost\n" + str(cost) + "\nLevel\n" + str(upgrades)

## Basic Ball
func _on_plus_ball_pressed() -> void:
	var cost = calculate_cost(base_cost_ball, ball_upgrades)
	if gameManR.getMoney() >= cost:
		gameManR.removeMoney(cost)
		ball_upgrades += 1
		gameMan.spawnBall("res://Ball/SplashDamageBall/SplashDamageBall.tscn")
		set_text(plusLabel, ball_upgrades, calculate_cost(base_cost_ball, ball_upgrades))
		#print("New Ball Purchased! Next cost: ", calculate_cost(base_cost_ball, ball_upgrades))
	else:
		pass
		#print("Not enough currency!")

## Basic Ball
func _on_power_pressed() -> void:
	var cost = calculate_cost(base_cost_power, power_upgrades)
	if gameManR.getMoney() >= cost:
		gameManR.removeMoney(cost)
		power_upgrades += 1
		basicBallR.setDamage(basicBallR.getDamage() + 1)
		set_text(powerLabel, power_upgrades, calculate_cost(base_cost_power, power_upgrades))
		#print("Power Upgraded! Next cost: ", calculate_cost(base_cost_power, power_upgrades))
	else:
		pass
		#print("Not enough currency!")

## Basic Ball
func _on_speed_pressed() -> void:
	var cost = calculate_cost(base_cost_speed, speed_upgrades)
	if gameManR.getMoney() >= cost:
		gameManR.removeMoney(cost)
		speed_upgrades += 1
		basicBallR.setSpeed(basicBallR.getSpeed() + 10)
		set_text(speedLabel, speed_upgrades, calculate_cost(base_cost_speed, speed_upgrades))
		#print("Speed Upgraded! Next cost: ", calculate_cost(base_cost_speed, speed_upgrades))
	else:
		pass
		#print("Not enough currency!")

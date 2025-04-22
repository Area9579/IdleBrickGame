extends CharacterBody2D
@export var ball: Ball
@onready var splash_damage_zone: Area2D = $SplashDamageZone

# Direction of movement (normalized vector)
var direction: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
# damage is necasary so we can call damage in the script BasicBrick.gd
var damage
func _physics_process(delta: float) -> void:
	# Calculate the movement vector
	var _velocity: Vector2 = direction * ball.getSpeed()
	damage = ball.getDamage()
	# Move the ball and handle collisions
	var collision: KinematicCollision2D = move_and_collide(_velocity * delta)
	# If a collision occurs, bounce the ball
	if collision:
		apply_splash_damage(collision.get_collider())
		if collision.get_collider() == StaticBody2D:
			apply_splash_damage(collision.get_collider())
			direction = direction.bounce((collision.get_normal() + Vector2(roll_nonzero(), roll_nonzero())).normalized())
		direction = direction.bounce(collision.get_normal())
		

func roll_nonzero() -> int:
	var value = 0
	while value == 0:
		value = randi_range(-1, 1)
	return value


func apply_splash_damage( collider: StaticBody2D ):
	if collider.get_parent().name.containsn("brick"):
		var bodies = splash_damage_zone.get_overlapping_bodies()
		for body in bodies:
			if body.get_parent().has_method("normalHit"):
				body.get_parent().normalHit(self.damage)

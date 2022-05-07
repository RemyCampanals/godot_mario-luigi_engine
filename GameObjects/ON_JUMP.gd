extends Node

onready var player: Player = get_parent().get_parent();

func ready():
	pass;

func start_process():
	player.velocity.y = player.jumpForce;
	playJumpAnimation(player.currentDirection);

func _physics_process(delta):
	var direction = player.getDirectionalInput().normalized();
	player.velocity = Vector3(direction.x * player.speed, player.velocity.y, direction.y * player.speed); 
	player.moveAndFallWithoutSnap(delta);

	if (player.velocity.y < 0):
		player.changeState(player.states.ON_FALL);
		return;

func playJumpAnimation(direction: int) -> void:
	var currentPosition = player.animation.current_animation_position;

	match direction:
		player.directions.UP:
			player.animation.play("JumpUp");
			player.animation.seek(currentPosition, true);
		player.directions.UP_RIGHT:
			player.animation.play("JumpUpRight");
			player.animation.seek(currentPosition, true);
		player.directions.UP_LEFT:
			player.animation.play("JumpUpLeft");
			player.animation.seek(currentPosition, true);
		player.directions.DOWN:
			player.animation.play("JumpDown");
			player.animation.seek(currentPosition, true);
		player.directions.DOWN_RIGHT:
			player.animation.play("JumpDownRight");
			player.animation.seek(currentPosition, true);
		player.directions.DOWN_LEFT:
			player.animation.play("JumpDownLeft");
			player.animation.seek(currentPosition, true);
		player.directions.RIGHT:
			player.animation.play("JumpRight");
			player.animation.seek(currentPosition, true);
		player.directions.LEFT:
			player.animation.play("JumpLeft");
			player.animation.seek(currentPosition, true);

func _on_direction_changed(direction):
	if (player.currentState == player.states.ON_JUMP):
		playJumpAnimation(direction);

func finish_process():
	player.animation.stop();

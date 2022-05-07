extends Node

onready var player: Player = get_parent().get_parent();

func ready():
	pass;

func start_process():
	playFallAnimation(player.currentDirection);

func _physics_process(delta):
	var direction = player.getDirectionalInput().normalized();
	player.velocity = Vector3(direction.x * player.speed, player.velocity.y, direction.y * player.speed); 
	player.moveAndFallWithoutSnap(delta);
	
	if (player.is_on_floor()):
		player.changeState(player.states.ON_IDLE);
		return;

func playFallAnimation(direction: int) -> void:
	var currentPosition = player.animation.current_animation_position;

	match direction:
		player.directions.UP:
			player.animation.play("FallUp");
			player.animation.seek(currentPosition, true);
		player.directions.UP_RIGHT:
			player.animation.play("FallUpRight");
			player.animation.seek(currentPosition, true);
		player.directions.UP_LEFT:
			player.animation.play("FallUpLeft");
			player.animation.seek(currentPosition, true);
		player.directions.DOWN:
			player.animation.play("FallDown");
			player.animation.seek(currentPosition, true);
		player.directions.DOWN_RIGHT:
			player.animation.play("FallDownRight");
			player.animation.seek(currentPosition, true);
		player.directions.DOWN_LEFT:
			player.animation.play("FallDownLeft");
			player.animation.seek(currentPosition, true);
		player.directions.RIGHT:
			player.animation.play("FallRight");
			player.animation.seek(currentPosition, true);
		player.directions.LEFT:
			player.animation.play("FallLeft");
			player.animation.seek(currentPosition, true);

func _on_direction_changed(direction):
	if (player.currentState == player.states.ON_FALL):
		playFallAnimation(direction);

func finish_process():
	player.animation.stop(true);
	player.velocity.y = 0.0;

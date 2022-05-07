extends Node

onready var player: Player = get_parent().get_parent();

func ready():
	pass;

func start_process():
	playWalkAnimation(player.currentDirection);

func _physics_process(delta):
	if (not player.is_on_floor()):
		player.changeState(player.states.ON_FALL);
		return;

	var direction = player.getDirectionalInput().normalized();

	if (not Input.is_action_pressed("move_down") 
		and not Input.is_action_pressed("move_up")
		and not Input.is_action_pressed("move_left")
		and not Input.is_action_pressed("move_right")
		and player.is_on_floor()):
		player.changeState(player.states.ON_IDLE);
		return;

	if (Input.is_action_just_pressed("jump")):
		player.changeState(player.states.ON_JUMP);
		return;

	player.velocity = Vector3(direction.x * player.speed, player.velocity.y, direction.y * player.speed); 
	player.moveAndFall(delta);

func playWalkAnimation(direction: int) -> void:
	var currentPosition = player.animation.current_animation_position;

	match direction:
		player.directions.UP:
			player.animation.play("WalkUp");
			player.animation.seek(currentPosition, true);
		player.directions.UP_RIGHT:
			player.animation.play("WalkUpRight");
			player.animation.seek(currentPosition, true);
		player.directions.UP_LEFT:
			player.animation.play("WalkUpLeft");
			player.animation.seek(currentPosition, true);
		player.directions.DOWN:
			player.animation.play("WalkDown");
			player.animation.seek(currentPosition, true);
		player.directions.DOWN_RIGHT:
			player.animation.play("WalkDownRight");
			player.animation.seek(currentPosition, true);
		player.directions.DOWN_LEFT:
			player.animation.play("WalkDownLeft");
			player.animation.seek(currentPosition, true);
		player.directions.RIGHT:
			player.animation.play("WalkRight");
			player.animation.seek(currentPosition, true);
		player.directions.LEFT:
			player.animation.play("WalkLeft");
			player.animation.seek(currentPosition, true);
	
func _on_direction_changed(direction):
	if (player.currentState == player.states.ON_WALK):
		playWalkAnimation(direction);

func finish_process():
	player.animation.stop();

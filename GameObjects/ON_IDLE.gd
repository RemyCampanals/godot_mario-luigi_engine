extends Node

onready var player: Player = get_parent().get_parent();

func ready():
	pass;

func start_process():
	match player.currentDirection:
		player.directions.UP:
			player.animation.play("IdleUp");
		player.directions.UP_RIGHT:
			player.animation.play("IdleUpRight");
		player.directions.UP_LEFT:
			player.animation.play("IdleUpLeft");
		player.directions.DOWN:
			player.animation.play("IdleDown");
		player.directions.DOWN_RIGHT:
			player.animation.play("IdleDownRight");
		player.directions.DOWN_LEFT:
			player.animation.play("IdleDownLeft");
		player.directions.RIGHT:
			player.animation.play("IdleRight");
		player.directions.LEFT:
			player.animation.play("IdleLeft");

func _physics_process(delta):
	if (Input.is_action_pressed("move_down") 
		or Input.is_action_pressed("move_up")
		or Input.is_action_pressed("move_left")
		or Input.is_action_pressed("move_right")):
		player.changeState(player.states.ON_WALK);
		return;
	
	if (Input.is_action_just_pressed("jump")):
		player.changeState(player.states.ON_JUMP);
		return;

func finish_process():
	pass;

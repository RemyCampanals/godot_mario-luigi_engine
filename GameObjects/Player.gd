extends KinematicBody

class_name Player

signal direction_changed(direction);

export var speed: float = 2.0;
export var fallForce: float = 10.0;
export var maxFallForce: float = 10.0;
export var jumpForce: float = 6;
var velocity: Vector3 = Vector3.ZERO;

enum states { ON_IDLE, ON_WALK, ON_JUMP, ON_FALL };
var currentState = states.ON_IDLE;

enum directions { UP, DOWN, LEFT, RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT };
var currentDirection = directions.DOWN;

onready var animation: AnimationPlayer = $Sprite3D/AnimationPlayer;

func _ready():
	changeState(currentState);

func changeState(state: int) -> void:
	if (currentState == states.ON_IDLE):
		$STATES_MACHINE/ON_IDLE.finish_process();
	if (currentState == states.ON_WALK):
		$STATES_MACHINE/ON_WALK.finish_process();
	if (currentState == states.ON_JUMP):
		$STATES_MACHINE/ON_JUMP.finish_process();
	if (currentState == states.ON_FALL):
		$STATES_MACHINE/ON_FALL.finish_process();

	$STATES_MACHINE/ON_IDLE.set_physics_process(false);
	$STATES_MACHINE/ON_WALK.set_physics_process(false);
	$STATES_MACHINE/ON_JUMP.set_physics_process(false);
	$STATES_MACHINE/ON_FALL.set_physics_process(false);
	
	currentState = state;
	match(currentState):
		states.ON_IDLE:
			$STATES_MACHINE/ON_IDLE.start_process();
			$STATES_MACHINE/ON_IDLE.set_physics_process(true);
		states.ON_WALK:
			$STATES_MACHINE/ON_WALK.start_process();
			$STATES_MACHINE/ON_WALK.set_physics_process(true);
		states.ON_JUMP:
			$STATES_MACHINE/ON_JUMP.start_process();
			$STATES_MACHINE/ON_JUMP.set_physics_process(true);
		states.ON_FALL:
			$STATES_MACHINE/ON_FALL.start_process();
			$STATES_MACHINE/ON_FALL.set_physics_process(true);

func _physics_process(delta) -> void:
	var direction = getDirectionalInput().normalized();
	updateCurrentDirection(direction);
	
	velocity.y -= fallForce * delta;
	
func getDirectionalInput() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	);

func updateCurrentDirection(direction: Vector2):
	var newDirection = null;

	if (direction.y > 0 && direction.x == 0):
		newDirection = directions.DOWN;
	elif (direction.y > 0 && direction.x > 0):
		newDirection = directions.DOWN_RIGHT;
	elif (direction.y == 0 && direction.x > 0):
		newDirection = directions.RIGHT;
	elif (direction.y < 0 && direction.x > 0):
		newDirection = directions.UP_RIGHT;
	elif (direction.y < 0 && direction.x == 0):
		newDirection = directions.UP;
	elif (direction.y < 0 && direction.x < 0):
		newDirection = directions.UP_LEFT;
	elif (direction.y == 0 && direction.x < 0):
		newDirection = directions.LEFT;
	elif (direction.y > 0 && direction.x < 0):
		newDirection = directions.DOWN_LEFT;
	
	if (newDirection != null && currentDirection != newDirection):
		currentDirection = newDirection;
		emit_signal("direction_changed", newDirection);

func moveAndFall(delta):
	velocity.y -= fallForce * delta;
	if (velocity.y > maxFallForce):
		velocity.y = maxFallForce;
	velocity.y = move_and_slide_with_snap(velocity, Vector3(0, 15, 0), Vector3.UP, true).y;

func moveAndFallWithoutSnap(delta):
	velocity.y -= (fallForce) * delta;
	velocity.y = move_and_slide(velocity, Vector3.UP).y;

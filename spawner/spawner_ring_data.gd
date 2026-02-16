class_name SpawnerRingData
extends Resource

## If repetitions are equal to 0 it's considered
## as if the spawner should continue creating projectiles.
@export var repetitions : int = 1

@export var spawnCooldown : float = 1.0
@export var initialAngle : float = 0.0
@export var deltaAngle : float = 0.0
@export var arms : int = 1
@export var lifetime : float = 0.0

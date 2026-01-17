class_name BulletData
extends Resource

@export var moveFunc : Callable = func (time): return Vector3(0.0, 0.0, 0.0)
@export var damage : float = 1.0
@export var maxLifeTime : float = 5.0
@export var texture : Texture2D = null

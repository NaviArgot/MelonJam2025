@abstract class_name ParametricMovement
extends Resource

## Computes a position using a parametric function.
## It needs to move towards the +X axis to guarantee 
## that it works with Projectile.faceTowards().
@abstract func getPosition (time : float) -> Vector3

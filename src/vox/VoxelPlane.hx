package vox;

@:structInit
class VoxelPlane {
	public final normal: VoxelNormal;
	public final position: Int;
	public final color: Color;

	public inline function toString()
		return '$normal/$position/$color';
}

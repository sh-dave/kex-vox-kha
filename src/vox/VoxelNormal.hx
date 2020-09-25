package vox;

@:structInit
class VoxelNormal {
	public final axis: VoxelAxis;
	public final sign: Int;

	public inline function toString()
		return '$axis/$sign';
}

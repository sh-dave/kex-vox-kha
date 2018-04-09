package kex.vox;

@:structInit
class VoxelNormal {
	public var axis: VoxelAxis;
	public var sign: Int;

	public function toString() : String {
		return '$axis/$sign';
	}
}

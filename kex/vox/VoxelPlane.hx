package kex.vox;

@:structInit
class VoxelPlane {
	public var normal: VoxelNormal;
	public var position: Int;
	public var color: Color;

	public function toString() : String {
		return '${normal.toString()}/$position/$color';
	}
}

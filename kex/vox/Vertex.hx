package kex.vox;

import kha.math.Vector3;

@:structInit
class Vertex {
	public var position: Vector3;
	public var normal: Vector3;
	// public var texture: Vector3;
	public var color: Color;
	// public var output: Vector4;

	public function new( position: Vector3 ) {
		this.position = { x: position.x, y: position.y, z: position.z }
		this.normal = new Vector3();
	}
}

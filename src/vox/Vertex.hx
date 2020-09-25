package vox;

import kha.math.Vector3;

@:structInit
class Vertex {
	public final position: Vector3;
	public final normal: Vector3;
	// public var texture: Vector3;
	public final color: Color;
	// public var output: Vector4;

	public function new( position: Vector3 ) {
		this.position = { x: position.x, y: position.y, z: position.z }
		this.normal = new Vector3();
		this.color = { r: 1, g: 1, b: 1, a: 1 }
	}
}

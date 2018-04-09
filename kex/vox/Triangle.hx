package kex.vox;

import kha.math.Vector3;

using kex.Vector3Tools;

class Triangle {
	public var v1: Vertex;
	public var v2: Vertex;
	public var v3: Vertex;

	public function new( p1: Vector3, p2: Vector3, p3: Vector3 ) {
		v1 = new Vertex(p1);
		v2 = new Vertex(p2);
		v3 = new Vertex(p3);
	}

	public function normal() : Vector3 {
		var e1 = v2.position.sub(v1.position);
		var e2 = v3.position.sub(v1.position);
		return e1.cross(e2).normalized();
	}

	public function fixNormals() {
		var n = normal();

		if (v1.normal.isZero()) {
			v1.normal.setFrom(n);
		}

		if (v2.normal.isZero()) {
			v2.normal.setFrom(n);
		}

		if (v3.normal.isZero()) {
			v3.normal.setFrom(n);
		}
	}
}

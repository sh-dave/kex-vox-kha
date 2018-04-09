package kex;

import kha.math.Vector3;

class Vector3Tools {
	@:extern public static inline function normalized( v: Vector3 ) : Vector3 {
		var r = new Vector3(v.x, v.y, v.z);
		r.normalize();
		return r;
	}

	@:extern public static inline function isZero( v: Vector3 ) : Bool
		return v.x == 0 && v.y == 0 && v.z == 0;

	@:extern public static inline function swap( a: Vector3, b: Vector3 ) {
		// var tmp = new Vector3(a.x, a.y, a.z);
		// a.setFrom(b);
		// b.setFrom(tmp);
		var tmp = a.x;
		a.x = b.x;
		b.x = tmp;

		tmp = a.y;
		a.y = b.y;
		b.y = tmp;

		tmp = a.z;
		a.z = b.z;
		b.z = tmp;
	}
}

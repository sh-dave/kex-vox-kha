package;

import kha.math.Vector3;

class KhaVector3Ext {
	public static inline function isZero( v: Vector3 )
		return v.x == 0 && v.y == 0 && v.z == 0;

	public static inline function swap( a: Vector3, b: Vector3 ) {
		final tmpx = a.x;
		a.x = b.x;
		b.x = tmpx;

		final tmpy = a.y;
		a.y = b.y;
		b.y = tmpy;

		final tmpz = a.z;
		a.z = b.z;
		b.z = tmpz;
	}
}

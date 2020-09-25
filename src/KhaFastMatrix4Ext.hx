package;

import kha.math.FastMatrix4;

class KhaFastMatrix4Ext {
	public static inline function fromFastMatrix4( m: Class<FastMatrix4>, other: FastMatrix4 )
		return new FastMatrix4(
			other._00, other._10, other._20, other._30,
			other._01, other._11, other._21, other._31,
			other._02, other._12, other._22, other._32,
			other._03, other._13, other._23, other._33
		);
}

package kex.vox;

@:structInit
class Color {
	public var r: Float;
	public var g: Float;
	public var b: Float;
	public var a: Float;

	public function toString() : String
		return '$r/$g/$b/$a';
}

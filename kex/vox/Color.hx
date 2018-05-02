package kex.vox;

@:structInit
class Color {
	public var r: Int;//Float;
	public var g: Int;//Float;
	public var b: Int;//Float;
	public var a: Int;//Float;

	@:keep public function toString() : String
		return '$r/$g/$b/$a';
}

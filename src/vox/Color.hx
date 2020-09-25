package vox;

@:structInit
class Color {
	public final r: Int;
	public final g: Int;
	public final b: Int;
	public final a: Int;

	@:keep public inline function toString()
		return '$r/$g/$b/$a';
}

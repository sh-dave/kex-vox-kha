package kex.vox;

import kha.math.Vector3;

using kex.Vector3Tools;

class VoxelTools {
	public static function combineVoxelFaces( faces: Array<VoxelFace> ) : Array<VoxelFace> {
		// TODO (DK) could use Vox.size?
		var i0 = faces[0].i0;
		var j0 = faces[0].j0;
		var i1 = faces[0].i1;
		var j1 = faces[0].j1;

		for (f in faces) {
			if (f.i0 < i0) {
				i0 = f.i0;
			}

			if (f.j0 < j0) {
				j0 = f.j0;
			}

			if (f.i1 > i1) {
				i1 = f.i1;
			}

			if (f.j1 > j1) {
				j1 = f.j1;
			}
		}

		var nj = j1 - j0 + 1;
		var ni = i1 - i0 + 1;
		var a: Array<Array<Int>> = [for (j in 0...nj) [for (i in 0...ni) 0]];
		var w: Array<Array<Int>> = [for (j in 0...nj) [for (i in 0...ni) 0]];
		var h: Array<Array<Int>> = [for (j in 0...nj) [for (i in 0...ni) 0]];

		var count = 0;

		for (f in faces) {
			for (j in f.j0...f.j1 + 1) {
				for (i in f.i0...f.i1 + 1) {
					a[j - j0][i - i0] = 1;
					count += 1;
				}
			}
		}

		var result: Array<VoxelFace> = [];

		while (count > 0) {
			var maxArea: Int = 0;
			var maxFace: VoxelFace = null;

			for (j in 0...nj) {
				for (i in 0...ni) {
					if (a[j][i] == 0) {
						continue;
					}

					if (j == 0) {
						h[j][i] = 1;
					} else {
						h[j][i] = h[j - 1][i] + 1;
					}

					if (i == 0) {
						w[j][i] = 1;
					} else {
						w[j][i] = w[j][i - 1] + 1;
					}

					var minw = w[j][i];

					for (dh in 0...h[j][i]) {
						if (w[j - dh][i] < minw) {
							minw = w[j - dh][i];
						}

						var area = (dh + 1) * minw;

						if (area > maxArea) {
							maxArea = area;
							maxFace = {
								i0: i0 + i - minw + 1,
								j0: j0 + j - dh,
								i1: i0 + i,
								j1: j0 + j
							}
						}
					}
				}
			}

			if (maxFace == null) {
				throw 'no maxFace'; // TODO (DK) tmp
			}

			result.push(maxFace);

			for (j in maxFace.j0...maxFace.j1 + 1) {
				for (i in maxFace.i0...maxFace.i1 + 1) {
					a[j - j0][i - i0] = 0;
					count -= 1;
				}
			}

			for (j in 0...nj) {
				for (i in 0...ni) {
					w[j][i] = 0;
					h[j][i] = 0;
				}
			}
		}

		return result;
	}

	public static function triangulateVoxelFaces( plane: VoxelPlane, faces: Array<VoxelFace> ) : Array<Triangle> {
		var triangles: Array<Triangle> = [];
		triangles[faces.length * 2 - 1] = null;
		var k = plane.position + plane.normal.sign * 0.5;

		var p1 = new Vector3();
		var p2 = new Vector3();
		var p3 = new Vector3();
		var p4 = new Vector3();

		for (i in 0...faces.length) {
			var face = faces[i];
			var i0 = face.i0 - 0.5;
			var j0 = face.j0 - 0.5;
			var i1 = face.i1 + 0.5;
			var j1 = face.j1 + 0.5;

			switch plane.normal.axis {
				case VoxelX:
					p1.setFrom(new Vector3(k, i0, j0));
					p2.setFrom(new Vector3(k, i1, j0));
					p3.setFrom(new Vector3(k, i1, j1));
					p4.setFrom(new Vector3(k, i0, j1));
				case VoxelY:
					p1.setFrom(new Vector3(i0, k, j1));
					p2.setFrom(new Vector3(i1, k, j1));
					p3.setFrom(new Vector3(i1, k, j0));
					p4.setFrom(new Vector3(i0, k, j0));
				case VoxelZ:
					p1.setFrom(new Vector3(i0, j0, k));
					p2.setFrom(new Vector3(i1, j0, k));
					p3.setFrom(new Vector3(i1, j1, k));
					p4.setFrom(new Vector3(i0, j1, k));
			}

			if (plane.normal.sign < 0) {
				p1.swap(p4);
				p2.swap(p3);
			}

			var t1 = new Triangle(p1, p2, p3);
			var t2 = new Triangle(p1, p3, p4);
			t1.fixNormals();
			t2.fixNormals();
			t1.v1.color = plane.color;
			t1.v2.color = plane.color;
			t1.v3.color = plane.color;
			t2.v1.color = plane.color;
			t2.v2.color = plane.color;
			t2.v3.color = plane.color;
			triangles[i * 2 + 0] = t1;
			triangles[i * 2 + 1] = t2;
		}

		return triangles;
	}

	// TODO (DK) cleanup the string lookup mess
	public static function newVoxelMesh( voxels: Array<Voxel> ) : Array<Triangle> {
		var lookup = new Map<String, Bool>();

		for (v in voxels) {
			lookup.set('${v.x}/${v.y}/${v.z}', true);
		}

		var planeFaces: PlaneFaceArray = [];

		function append( pf: PlaneFaceArray, plane: VoxelPlane, face: VoxelFace ) {
			var key = plane.toString();
			var entry = Lambda.find(pf, function( e ) return e.key == key);

			if (entry == null) {
				entry = { key: key, plane: plane, faces: [face] }
				planeFaces.push(entry);
			} else {
				entry.faces.push(face);
			}

			return pf;
		}

		for (v in voxels) {
			if (!lookup.get('${v.x + 1}/${v.y}/${v.z}')) {
				var plane: VoxelPlane = { normal: Const.VoxelPosX, position: v.x, color: v.color }
				var face: VoxelFace = { i0: v.y, j0: v.z, i1: v.y, j1: v.z }
				planeFaces = append(planeFaces, plane, face);
			}

			if (!lookup.get('${v.x - 1}/${v.y}/${v.z}')) {
				var plane: VoxelPlane = { normal: Const.VoxelNegX, position: v.x, color: v.color }
				var face: VoxelFace = { i0: v.y, j0: v.z, i1: v.y, j1: v.z }
				planeFaces = append(planeFaces, plane, face);
			}

			if (!lookup.get('${v.x}/${v.y + 1}/${v.z}')) {
				var plane: VoxelPlane = { normal: Const.VoxelPosY, position: v.y, color: v.color }
				var face: VoxelFace = { i0: v.x, j0: v.z, i1: v.x, j1: v.z }
				planeFaces = append(planeFaces, plane, face);
			}

			if (!lookup.get('${v.x}/${v.y - 1}/${v.z}')) {
				var plane: VoxelPlane = { normal: Const.VoxelNegY, position: v.y, color: v.color }
				var face: VoxelFace = { i0: v.x, j0: v.z, i1: v.x, j1: v.z }
				planeFaces = append(planeFaces, plane, face);
			}

			if (!lookup.get('${v.x}/${v.y}/${v.z + 1}')) {
				var plane: VoxelPlane = { normal: Const.VoxelPosZ, position: v.z, color: v.color }
				var face: VoxelFace = { i0: v.x, j0: v.y, i1: v.x, j1: v.y }
				planeFaces = append(planeFaces, plane, face);
			}

			if (!lookup.get('${v.x}/${v.y}/${v.z - 1}')) {
				var plane: VoxelPlane = { normal: Const.VoxelNegZ, position: v.z, color: v.color }
				var face: VoxelFace = { i0: v.x, j0: v.y, i1: v.x, j1: v.y }
				planeFaces = append(planeFaces, plane, face);
			}
		}

		var triangles: Array<Triangle> = [];

		for (entry in planeFaces) {
			var plane = entry.plane;
			var faces = combineVoxelFaces(entry.faces);
			triangles = triangles.concat(triangulateVoxelFaces(plane, faces));
		}

		return triangles;
		// return {
		// 	mesh: triangles,
		// 	position: new Vector3(),
		// }
	}
}

package arm;
import kex.vox.VoxelTools;
import kex.vox.Voxel;
import kex.vox.Triangle;
//import kex.vox.MeshFactory;

import iron.Scene;
import iron.data.SceneFormat;
import iron.data.MeshData;
import iron.data.MaterialData;
import iron.data.Data;
import iron.object.Transform;
import iron.object.MeshObject;
import iron.system.Input;
import iron.math.Vec4;
import iron.math.RayCaster;
import iron.math.Ray;
import armory.trait.physics.bullet.PhysicsWorld;
import armory.trait.physics.bullet.RigidBody;

class VoxelChunk {
	var Voxels:Array<Voxel>;
	var meshDate:MaterialData;
	var meshObject:MeshObject;
	var transform:Transform;
}

class Editor extends iron.Trait {
	public function new() {

		super();

		// notifyOnInit(function() {
		// });

		// notifyOnUpdate(function() {
		// });

		// notifyOnRemove(function() {
		// });
	}
}

package arm;

import iron.math.Vec2;
import haxe.ds.ArraySort;
import js.html.svg.Length;
import iron.math.Mat4;
import kha.audio2.ogg.vorbis.data.Page;
import js.Error.RangeError;
import iron.math.Vec3;
import iron.math.Quat;

import iron.object.Object;
import iron.object.Transform;
import iron.Scene;
import haxe.io.Input;
import iron.math.Vec4;
import iron.system.Input;
import armory.trait.physics.PhysicsWorld;
import armory.trait.physics.RigidBody;
import iron.math.RayCaster;

class Cursor extends iron.Trait {
	
	var XR = 0.0;
	var ZR = (Math.PI*2)/2;
	var F = 20.0;
	var grid:Array<Array<Array<Int> > > = [for (x in 0...10) [for (y in 0...10)  [for (z in 0...10)0]    ]          ];

	public function setVox(T){
		var loc = new Vec4();
		loc.x = Std.int(ray().x);
		loc.y = Std.int(ray().y);
		loc.z = Std.int(ray().z);
		if (loc.x < 0){
				loc.x = 0;
		}
		if (loc.x > grid.length-1){
				loc.x = grid.length-1;
		}
		if (loc.y < 0){
			loc.y = 0;
		}
		if (loc.y > grid.length-1){
			loc.y = grid.length-1;
		}
		if (loc.z < 0){
			loc.z = 0;
		}
		if (loc.z > grid.length-1){
			loc.z = grid.length-1;
		}
		if (T == 1){
			grid[Std.int(loc.x)][Std.int(loc.y)][Std.int(loc.z)] = 1;
		}	
		if(T == 0){
			var obj = Scene.active.getMesh(Mpos(1));
			if (StringTools.endsWith(obj.name, "v")){
				grid[Std.int(obj.transform.loc.x)][Std.int(obj.transform.loc.y)][Std.int(obj.transform.loc.z)]= 0;
			};
		}
		//grid[Std.int(loc.x)][Std.int(loc.y)][Std.int(loc.z)] = 1;	
	}

	public function UpdateGrid(){
		var vox = Scene.active.getMesh("cube");
		var buffer = new Array();
		function setbox(x,y,z){
			Scene.active.spawnObject("cube",vox, function(o:Object){
					object = o;
					object.name = Std.string([x,y,z])+"v";
					object.transform.loc.x = x;
					object.transform.loc.y = y;
					object.transform.loc.z = z;
					object.visible = true;
					var rigidBody = object.getTrait(RigidBody);
					if (rigidBody != null) rigidBody.syncTransform();
					object.transform.buildMatrix();
				},false);
		}
		for (x in 0...Scene.active.meshes.length){
			//trace(Scene.active.meshes[x].name);
			//trace(x);
			var obj = Scene.active.meshes[x].name; 
			if (StringTools.endsWith(obj, "v")){
				//trace(Scene.active.meshes[x].name);
				buffer.push(obj);
				//Scene.active.getMesh(obj).remove();
			};
		}
		for (b in buffer){
			Scene.active.getMesh(b).remove();
		}

		for (x in 0...(grid.length)) for (y in 0...(grid.length))  for (z in 0...(grid.length)){
			if (grid[x][y][z] == 1){
				if (x == 0 || x == grid.length-1 || y == 0 || y == grid.length-1 || z == grid.length-1 ){
					setbox(x,y,z);
				}
				else if (grid[x-1][y][z] == 0 || grid[x+1][y][z] == 0 || grid[x][y-1][z] == 0 || grid[x][y+1][z] == 0 || grid[x][y][z-1] == 0 || grid[x][y][z+1] == 0 ) {
					setbox(x,y,z);
				}
			}
			
		}
		//trace(Scene.active.meshes[0].);
	}
	
	public function GetDir(){
		var mo = Input.getMouse();
		var oridir = RayCaster.getRay(mo.x,mo.y,Scene.active.getCamera("cam")).direction;
		return oridir.normalize();
		
		
	}
	
	public function ray(){
		var cam = Scene.active.getCamera("cam");
		var mdis = F + F/2;
		var step = 0;
		var hit = false;
		var p = new Vec4();
		var rd = GetDir();
		var ro = cam.transform.loc;
		for (i in 0...1000){
			p.x = ro.x + (rd.x *step * 0.1);
			p.y = ro.y + (rd.y *step* 0.1);
			p.z = ro.z + (rd.z *step* 0.1);
			step += 1;
			if(p.z < 0.0){
				p.z = 0.0;
				break;
			}
			if (p.x > 0.0 && p.x < grid.length && p.y > 0.0 && p.y < grid.length && p.z < grid.length){
				if ( grid[Std.int(p.x)][Std.int(p.y)][Std.int(p.z)] == 1){
						step -= 2;
						p.x = ro.x + (rd.x *step * 0.1);
						p.y = ro.y + (rd.y *step* 0.1);
						p.z = ro.z + (rd.z *step* 0.1);
						if(p.z < 0.0){
							p.z = 0.0;
						}
						
				}
			}
			
		}
		//trace(p);
		return p;
	}
		

	

	public function Mpos(T):Dynamic {
		var mo = Input.getMouse();
		var physics = PhysicsWorld.active;
		var rb = physics.pickClosest(mo.x, mo.y);
		var hit = physics.hitPointWorld;
		var nor = physics.hitNormalWorld;
		//if (rb == null) return null;
		if (T == 0){
			return hit;
		}
		if (T == 1){
			return nor;
		}
		if (rb != null){
			return rb.object.name;
		}
		else{return null;}
	}

	public function Nav(type):Float{
		var cam:iron.object.Object = iron.Scene.active.getChild("cam");
		var mo = Input.getMouse();
		function Setpos(){
			var fx = F * Math.sin(ZR)*Math.sin(XR);
			var fy = F * Math.sin(ZR)*Math.cos(XR);
			var fz = F * Math.cos(ZR);
			cam.transform.loc.x = fx +(grid.length/2);
			cam.transform.loc.y = fy +(grid.length/2);
			cam.transform.loc.z = fz;
		}

		if (type == 0){
			XR += mo.movementX*0.005;
			ZR -= mo.movementY*0.005;
			if (ZR < 0 ){
				ZR = 0.000000001;
			}
			if (ZR > (Math.PI/2)){
				ZR = (Math.PI/2)+0.000001;
			}

			//rot.x = ZR;//+ mo.movementY*0.005;
			//rot.z = ZR ;
			//rot.y = 0;
			Setpos();
			//cam.transform.setRotation(rot.x,rot.y,rot.z);
			//cam.transform.setRotation(-Math.PI + 1,Math.PI,XR);
			//cam.transform.setRotation(-(-Math.PI+ZR),Math.PI,XR+Math.PI);
			if (XR > Math.PI){
				XR -= (Math.PI*2);
			}
			if (XR < -Math.PI){
				XR += (Math.PI*2);
			}
			cam.transform.setRotation((-Math.PI+ZR),Math.PI,XR);
			cam.transform.buildMatrix();
			var rigidBody = cam.getTrait(RigidBody);
			if (rigidBody != null) rigidBody.syncTransform();
			//trace(XR);
		}
		if (type == 1){
			//trace(mo.wheelDelta);
			F += mo.wheelDelta;
			Setpos();
		}
		if (type == 3){
			Setpos();
			return null;
		}
		if (type == 4){
			return XR;
		}
		else return 0.0;
	}
	public function SetGrid(size:Int){
		grid = [for (x in 0...size) [for (y in 0...size)  [for (z in 0...size)1]    ]          ];
		Nav(3);
	}
	public function new() {
		//var grid:Array<Array<Array<Int> > > = [for (x in 0...10) [for (y in 0...10)  [for (z in 0...10)0]    ]          ];
		
		super();

		// notifyOnInit(function() {
		// });

		notifyOnUpdate(function() {
			var mo = Input.getMouse();
			var key = Input.getKeyboard();
			var select:iron.object.Object = iron.Scene.active.getChild("sel");
			var posi:Vec4 = new Vec4();
			posi.x = Std.int(ray().x);
			posi.y = Std.int(ray().y);
			posi.z = Std.int(ray().z);
			if (posi.x < 0){
				posi.x = 0;
			}
			if (posi.x > grid.length-1){
				posi.x = grid.length-1;
			}
			if (posi.y < 0){
				posi.y = 0;
			}
			if (posi.y > grid.length-1){
				posi.y = grid.length-1;
			}
			if (posi.z < 0){
				posi.z = 0;
			}
			if (posi.z > grid.length-1){
				posi.z = grid.length-1;
			}
			select.transform.loc = posi;
			select.transform.buildMatrix();
			var rigidBody = select.getTrait(RigidBody);
			if (rigidBody != null) rigidBody.syncTransform();
			//grid[0][1][0] = 1;
			//trace(grid[Std.int(posi.x)][Std.int(posi.y)][Std.int(posi.z)]);
			if (mo.down("middle")){
				Nav(0);
			}
			if (mo.wheelDelta != 0){
				Nav(1);
			}
			if (mo.started("right")){
				setVox(0);
				UpdateGrid();
			}
			if (mo.started("left")){
				//SetGrid(15);
				setVox(1);
				UpdateGrid();
			}
			if (key.started("1")){
				SetGrid(20);
			}
			
			
			
		});

		// notifyOnRemove(function() {
		// });
	}
}

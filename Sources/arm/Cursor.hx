package arm;

import iron.math.Vec2;
import haxe.ds.ArraySort;
import js.html.svg.Length;
import iron.math.Mat4;
import kha.audio2.ogg.vorbis.data.Page;
import js.Error.RangeError;
import iron.math.Vec3;
import iron.math.Quat;
import iron.math.Math;
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
	var ZR = Math.PI_2/2;
	var F = 20.0;
	var grid:Array<Array<Array<Int> > > = [for (x in 0...10) [for (y in 0...10)  [for (z in 0...10)0]    ]          ];

	public function setVox(T){
		var loc = new Vec4();
		loc.x = Std.int(raymarch().x);
		loc.y = Std.int(raymarch().y);
		loc.z = Math.round(raymarch().z);
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
	public function pickmin(array:Array<Float>){

	var mn = array[0];
		for (i in 0...array.length) {

			if (array[i]<mn) {

			mn = array[i];

			}

		}
		return mn;

	}
	
	public function GetDir(){
		var mo = Input.getMouse();
		var oridir = RayCaster.getRay(mo.x,mo.y,Scene.active.getCamera("cam")).direction;
		return oridir.normalize();
		
		
	}
	
	public function CubeDist(p:Vec4,c:Vec4,s:Vec4){
		var o = new Vec4();
		var max = Math.max;
		var min = Math.min;
		o.x = Math.abs(p.x-c.x) -s.x;
		o.y = Math.abs(p.y-c.y) -s.y;
		o.z = Math.abs(p.z-c.z) -s.z;
		//var n = max(max(min(o.x,0.0),min(o.y,0.0)),min(o.z,0.0));
		var n = min(max(o.x,max(o.y,o.z)),0.0);
		o.x = max(o.x,0.0);
		o.y = max(o.y,0.0);
		o.z = max(o.z,0.0);
		var ud = o.length();
		return ud ;
	
	}

	public function GetDist(p){
		var test = new Vec4();
		var s = new Vec4();
		var dist = [];
		s.x = 0.5;
		s.y = 0.5;
		s.z = 0.5;
		test.x = 1;
		test.y = 1;
		test.z = 1;
		for (x in 0...Scene.active.meshes.length){
			//trace(Scene.active.meshes[x].name);
			//trace(x);
			var obj = Scene.active.meshes[x].name; 
			if (StringTools.endsWith(obj, "v")){
				dist.push(CubeDist(p,Scene.active.getChild(obj).transform.loc,s));
				
			};
		}
		dist.push(Math.abs(p.z));
		if (Math.PI/2 < Nav(4) || Nav(4) < -Math.PI/2){
			dist.push(Math.abs(Math.pow(Math.pow((grid.length-p.y),2),0.5)));
		}
		if (Math.PI < Nav(4) || Nav(4) < 0.0){
			dist.push(Math.abs(Math.pow(Math.pow((grid.length-p.x),2),0.5)));
		}
		if (Nav(4)> 0.0){
			dist.push(Math.abs(p.x));
		}
		if (Nav(4)> -Math.PI/2 && Nav(4)< Math.PI/2){
			dist.push(Math.abs(p.y));
		}
		return pickmin(dist);
		//return Math.min(CubeDist(p,test,s),Math.abs(p.z));
	}

	public function raymarch(){
		var mstep = 100;
		var hit = 0.001;
		var cam = Scene.active.getCamera("cam");
		var ro = cam.transform.loc;
		//var rd = cam.transform.look().normalize();
		//var rd = Nav(4);
		var rd = GetDir();
		var dori = 0.0;
		var p = new Vec4();
		var ds = 0.0;
		var st = 0;
		for (i in 0...mstep){
			p.x = ro.x + (dori*rd.x);
			p.y = ro.y + (dori*rd.y);
			p.z = ro.z + (dori*rd.z);
			ds = GetDist(p);
			dori += ds;
			st += 1;
			
			if (ds < hit) break;
		}
		//trace(st);
		return p;
		
	
	}
		public function intbound(s:Float, ds:Float){
			if (ds < 0){
				s *= -1 ;
				ds *= -1 ;
			}
			s = Math.mod(s,1);
			return (1-s)/ds;
		}
	public function sign(x:Float):Float{
			return x < 0 ? -1:1;
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
			if (ZR > Math.PI_2){
				ZR = Math.PI_2+0.000001;
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
			posi.x = Std.int(raymarch().x);
			posi.y = Std.int(raymarch().y);
			posi.z = Math.round(raymarch().z);
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
			
			//trace(Raycast(Scene.active.getCamera("cam").transform.loc,GetDir()));
			
		});

		// notifyOnRemove(function() {
		// });
	}
}

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
	var ZR = (Math.PI)/3;
	var F = 20.0;
	var DX = 0.0;
	var DY = 0.0;
	var DZ = 0.0;
	var grid:Array<Array<Array<Int> > > = [for (x in 0...10) [for (y in 0...10)  [for (z in 0...10)0]    ]          ];
	var Bgrid = [for (x in 0...10) [for (y in 0...10)  [for (z in 0...10)[0,0,0,0,0,0,0]]    ]          ];
	var vox = Scene.active.getMesh("cube");
	

	function setbox(x,y,z,x2,y2,z2,face){
		Scene.active.spawnObject(face.name,vox, function(o:Object){
			object = o;
			object.name = face.name +Std.string([x,y,z])+"v";
			object.transform.loc.x = x;
			object.transform.loc.y = y;
			object.transform.loc.z = z;
			object.transform.scale.x = (x2-x)+1;
			object.transform.scale.y = (y2-y)+1;
			object.transform.scale.z = (z2-z)+1;
			object.visible = true;
			//var rigidBody = object.getTrait(RigidBody);
			//if (rigidBody != null) rigidBody.syncTransform();
			object.transform.buildMatrix();
		},false);
	}

	public function setVox(T){
		var loc = new Vec4();
		if (T == 1){
			loc.x = Std.int(ray(2).x);
			loc.y = Std.int(ray(2).y);
			loc.z = Std.int(ray(2).z);
		}
		if (T == 0){
			loc.x = Std.int(ray(1).x);
			loc.y = Std.int(ray(1).y);
			loc.z = Std.int(ray(1).z);
		}
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
			grid[Std.int(loc.x)][Std.int(loc.y)][Std.int(loc.z)] = 0;
		}
	}

	public function UpdateGrid(){
		Bgrid = [for (x in 0...grid.length) [for (y in 0...grid.length)  [for (z in 0...grid.length)[0,0,0,0,0,0,0]]    ]          ];
		var up = Scene.active.getMesh("up");
		var down = Scene.active.getMesh("down");
		var north = Scene.active.getMesh("north");
		var south = Scene.active.getMesh("south");
		var west = Scene.active.getMesh("west");
		var est = Scene.active.getMesh("est");

		var buffer = new Array();
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
				if (grid[x][y][z] == 1){
					if (x == 0){
						Bgrid[x][y][z][3] = 1;
					}
					else  if (grid[x-1][y][z] == 0){
						Bgrid[x][y][z][3] = 1;
					}

					if (x == grid.length-1){
						Bgrid[x][y][z][2] = 1;

					}
					else if (grid[x+1][y][z] == 0){
						Bgrid[x][y][z][2] = 1;
					}

					if (y == 0){
						Bgrid[x][y][z][4] = 1;
					}
					else if (grid[x][y-1][z] == 0){
						Bgrid[x][y][z][4] = 1;
					}

					if (y == grid.length-1){
						Bgrid[x][y][z][5] = 1;
					}
					else if (grid[x][y+1][z] == 0){
						Bgrid[x][y][z][5] = 1;
					}

					if (z != 0 && grid[x][y][z-1] ==0){
						Bgrid[x][y][z][1] = 1;
					}

					if (z == grid.length-1){
						//setbox(x,y,z,up);
						Bgrid[x][y][z][0] = 1;
					}
					else if (grid[x][y][z+1] == 0){
						//setbox(x,y,z,up);
						Bgrid[x][y][z][0] = 1;
					}
				}
			}
			
		}
		for (l in 0...2){
			for (x in 0...(grid.length)) for (y in 0...(grid.length))  for (z in 0...(grid.length)){
				Bgrid[x][y][z][6] = 0;
			};
				trace(l);
			for (z in 0...(grid.length)){
				for (x in 0...(grid.length)) for (y in 0...(grid.length)){
					var s = [null,null,null];
					var e = [null,null,null];
					var step = 0;
					var stop = 0;
					var x2 = 0;
					if (Bgrid[x][y][z][l] == 1 && Bgrid[x][y][z][6] == 0){
						s = [x,y,z];
						Bgrid[x][y][z][6] = 1;
						for (xx in 1...(grid.length-x)){
							if (Bgrid[x+xx][y][z][l] == 1 && Bgrid[x+xx][y][z][6] == 0 ){
								e = [x+xx,y,z];
								Bgrid[x+xx][y][z][6] = 1;
							};
							else{
								if (e[0] == null){
									//e = s;
								};
								break;
								};
						};
						if (e[0] == null){
							e[0] = s[0];
						}
						if (e[1] == null){
							e[1] = s[1];
						}
						if (e[2] == null){
							e[2] = s[2];
						}
						for (yy in 1...(grid.length-y+1)){
							
							for (xx in s[0]...e[0]+1){
								
								if (yy+y != grid.length){
									if (Bgrid[xx][y+yy][z][l] == 0 || Bgrid[xx][y+yy][z][6] == 1){
										stop = 1;
										break;
									};
								};
								else{
									stop = 1;
									break;
								}
							};

							if (stop == 0){
								for (xx in s[0]...e[0]+1){
									// trace("apply x");
									// trace(xx);
									// trace(y+yy);
									if (yy+y != grid.length){
									Bgrid[xx][y+yy][z][6] = 1;
									};
									else{Bgrid[xx][y+yy-1][z][6] = 1;}
								};
							};
							
							if (stop == 1){
								
								e[1] = (y+yy)-1;
								
								break;
							};
						};
						if (l == 1){
							setbox(s[0],s[1],s[2],e[0],e[1],e[2],down);
						};
						if (l == 0){
								setbox(s[0],s[1],s[2],e[0],e[1],e[2],up);
						}
						
						trace("s" +s);
						trace("e" +e);
						trace("");

					};
				};
			};
		};
		for (l in 4...6){
			for (x in 0...(grid.length)) for (y in 0...(grid.length))  for (z in 0...(grid.length)){
				Bgrid[x][y][z][6] = 0;
			};
				trace(l);
			for (y in 0...(grid.length)){
				for (x in 0...(grid.length)) for (z in 0...(grid.length)){
					var s = [null,null,null];
					var e = [null,null,null];
					var step = 0;
					var stop = 0;
					var x2 = 0;
					if (Bgrid[x][y][z][l] == 1 && Bgrid[x][y][z][6] == 0){
						s = [x,y,z];
						Bgrid[x][y][z][6] = 1;
						for (xx in 1...(grid.length-x)){
							if (Bgrid[x+xx][y][z][l] == 1 && Bgrid[x+xx][y][z][6] == 0 ){
								e = [x+xx,y,z];
								Bgrid[x+xx][y][z][6] = 1;
							};
							else{
								break;
							};
						};
						if (e[0] == null){
							e[0] = s[0];
						}
						if (e[1] == null){
							e[1] = s[1];
						}
						if (e[2] == null){
							e[2] = s[2];
						}
						for (zz in 1...(grid.length-z+1)){
							
							for (xx in s[0]...e[0]+1){
								
								if (zz+z != grid.length){
									if (Bgrid[xx][y][z+zz][l] == 0 || Bgrid[xx][y][z+zz][6] == 1){
										stop = 1;
										break;
									};
								};
								else{
									stop = 1;
									break;
								}
							};

							if (stop == 0){
								for (xx in s[0]...e[0]+1){
									// trace("apply x");
									// trace(xx);
									// trace(y+yy);
									if (zz+z != grid.length){
									Bgrid[xx][y][z+zz][6] = 1;
									};
									else{Bgrid[xx][y][z+zz-1][6] = 1;}
								};
							};
							
							if (stop == 1){
								
								e[2] = (z+zz)-1;
								
								break;
							};
						};
						if (l == 5){
							setbox(s[0],s[1],s[2],e[0],e[1],e[2],west);
						};
						if (l == 4){
								setbox(s[0],s[1],s[2],e[0],e[1],e[2],est);
						}
						
						trace("s" +s);
						trace("e" +e);
						trace("");

					};
				};
			};
		};
		for (l in 2...4){
			for (x in 0...(grid.length)) for (y in 0...(grid.length))  for (z in 0...(grid.length)){
				Bgrid[x][y][z][6] = 0;
			};
				trace(l);
			for (x in 0...(grid.length)){
				for (y in 0...(grid.length)) for (z in 0...(grid.length)){
					var s = [null,null,null];
					var e = [null,null,null];
					var step = 0;
					var stop = 0;
					var x2 = 0;
					if (Bgrid[x][y][z][l] == 1 && Bgrid[x][y][z][6] == 0){
						s = [x,y,z];
						Bgrid[x][y][z][6] = 1;
						for (yy in 1...(grid.length-y)){
							if (Bgrid[x][y+yy][z][l] == 1 && Bgrid[x][y+yy][z][6] == 0 ){
								e = [x,y+yy,z];
								Bgrid[x][y+yy][z][6] = 1;
							};
							else{
								break;
							};
						};
						if (e[0] == null){
							e[0] = s[0];
						}
						if (e[1] == null){
							e[1] = s[1];
						}
						if (e[2] == null){
							e[2] = s[2];
						}
						for (zz in 1...(grid.length-z+1)){
							
							for (yy in s[1]...e[1]+1){
								
								if (zz+z != grid.length){
									if (Bgrid[x][yy][z+zz][l] == 0 || Bgrid[x][yy][z+zz][6] == 1){
										stop = 1;
										break;
									};
								};
								else{
									stop = 1;
									break;
								}
							};

							if (stop == 0){
								for (yy in s[1]...e[1]+1){
									// trace("apply x");
									// trace(xx);
									// trace(y+yy);
									if (zz+z != grid.length){
									Bgrid[x][yy][z+zz][6] = 1;
									};
									else{Bgrid[x][yy][z+zz-1][6] = 1;}
								};
							};
							
							if (stop == 1){
								
								e[2] = (z+zz)-1;
								
								break;
							};
						};
						if (l == 3){
							setbox(s[0],s[1],s[2],e[0],e[1],e[2],south);
						};
						if (l == 2){
								setbox(s[0],s[1],s[2],e[0],e[1],e[2],north);
						}
						
						trace("s" +s);
						trace("e" +e);
						trace("");

					};
				};
			};
		};
		
		trace("");

		//trace(Scene.active.meshes[0].);
	}

	public function GetDir(){
		var mo = Input.getMouse();
		var oridir = RayCaster.getRay(mo.x,mo.y,Scene.active.getCamera("cam")).direction;
		return oridir.normalize();	
	}
	
	public function ray(T:Int){
		var cam = Scene.active.getCamera("cam");
		var mdis = F + F/2;
		var step = 0;
		var nstep = Std.int((F+(F/2))/0.1);
		var hit = false;
		var p = new Vec4();
		var rd = GetDir();
		var ro = cam.transform.loc;
		for (i in 0...nstep){
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
						step -= T;
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
		

	

	// public function Mpos(T):Dynamic {
	// 	var mo = Input.getMouse();
	// 	//var physics = PhysicsWorld.active;
	// 	//var rb = physics.pickClosest(mo.x, mo.y);
	// 	//var hit = physics.hitPointWorld;
	// 	//var nor = physics.hitNormalWorld;
	// 	//if (rb == null) return null;
	// 	if (T == 0){
	// 		return hit;
	// 	}
	// 	if (T == 1){
	// 		return nor;
	// 	}
	// 	//if (rb != null){
	// 	//	return rb.object.name;
	// 	//}
	// 	else{return null;}
	// }

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
			trace(cam.transform.rot.getEuler());
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
			// var rigidBody = cam.getTrait(RigidBody);
			// if (rigidBody != null) rigidBody.syncTransform();
			// //trace(XR);
		}
		if (type == 1){
			//trace(mo.wheelDelta);
			F += mo.wheelDelta * (grid.length/2.5);
			Setpos();
		}
		if (type == 3){
			Setpos();
			return null;
		}
		if (type == 4){
			return 2.0;	
		}
		else return 0.0;
	}
	public function SetGrid(size:Int){
		grid = [for (x in 0...size) [for (y in 0...size)  [for (z in 0...size)1]    ]          ];
		Bgrid = [for (x in 0...size) [for (y in 0...size)  [for (z in 0...size)[0,0,0,0,0,0,0]]    ]          ];
		UpdateGrid();
		
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
			posi.x = Std.int(ray(2).x);
			posi.y = Std.int(ray(2).y);
			posi.z = Std.int(ray(2).z);
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
			// var rigidBody = select.getTrait(RigidBody);
			// if (rigidBody != null) rigidBody.syncTransform();
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

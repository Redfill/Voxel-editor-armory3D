// Auto-generated
let project = new Project('voxel editor');

project.addSources('Sources');
project.addLibrary("/home/redfill/Documents/Armory/armsdk/armory");
project.addLibrary("/home/redfill/Documents/Armory/armsdk/iron");
project.addLibrary("kex-vox-kha");
project.addLibrary("haxe-format-vox");
project.addLibrary("kex-vox-iron");
project.addLibrary("/home/redfill/Documents/Armory/armsdk/lib/haxebullet");
project.addAssets("/home/redfill/Documents/Armory/armsdk/lib/haxebullet/ammo/ammo.js", { notinlist: true });
project.addParameter('armory.trait.physics.bullet.PhysicsWorld');
project.addParameter("--macro keep('armory.trait.physics.bullet.PhysicsWorld')");
project.addParameter('armory.trait.physics.bullet.RigidBody');
project.addParameter("--macro keep('armory.trait.physics.bullet.RigidBody')");
project.addParameter('arm.Cursor');
project.addParameter("--macro keep('arm.Cursor')");
project.addShaders("build_voxel editor/compiled/Shaders/*.glsl", { noembed: false});
project.addAssets("build_voxel editor/compiled/Assets/**", { notinlist: true });
project.addAssets("build_voxel editor/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("textures/cube.png", { notinlist: true });
project.addDefine('rp_renderer=Forward');
project.addDefine('rp_background=Clear');
project.addDefine('arm_audio');
project.addDefine('arm_physics');
project.addDefine('arm_bullet');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_skin');
project.addDefine('arm_particles');


resolve(project);

// Auto-generated
let project = new Project('voxel editor');

project.addSources('Sources');
project.addLibrary("/home/redfill/Documents/Armory/armsdk/armory");
project.addLibrary("/home/redfill/Documents/Armory/armsdk/iron");
project.addLibrary("kex-vox-kha");
project.addLibrary("haxe-format-vox");
project.addLibrary("kex-vox-iron");
project.addParameter('armory.trait.internal.Bridge');
project.addParameter("--macro keep('armory.trait.internal.Bridge')");
project.addParameter('arm.Cursor');
project.addParameter("--macro keep('arm.Cursor')");
project.addParameter('armory.trait.internal.DebugConsole');
project.addParameter("--macro keep('armory.trait.internal.DebugConsole')");
project.addShaders("build_voxel editor/compiled/Shaders/*.glsl", { noembed: false});
project.addAssets("build_voxel editor/compiled/Assets/**", { notinlist: true });
project.addAssets("build_voxel editor/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("/home/redfill/Documents/Armory/armsdk/armory/Assets/brdf.png", { notinlist: true });
project.addShaders("/home/redfill/Documents/Armory/armsdk/armory/Shaders/debug_draw/**");
project.addParameter('--times');
project.addLibrary("/home/redfill/Documents/Armory/armsdk/lib/zui");
project.addAssets("/home/redfill/Documents/Armory/armsdk/armory/Assets/font_default.ttf", { notinlist: false });
project.addDefine('rp_renderer=Forward');
project.addDefine('rp_background=Clear');
project.addDefine('kha_no_ogg');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_debug');
project.addDefine('arm_ui');
project.addDefine('arm_deinterleaved');


resolve(project);

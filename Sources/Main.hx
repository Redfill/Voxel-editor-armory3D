// Auto-generated
package ;
class Main {
    public static inline var projectName = 'voxel editor';
    public static inline var projectPackage = 'arm';
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 8;
        armory.system.Starter.main(
            'Scene',
            0,
            false,
            true,
            false,
            960,
            540,
            1,
            true,
            armory.renderpath.RenderPathCreator.get
        );
    }
}

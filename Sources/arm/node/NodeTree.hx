package arm.node;

@:keep class NodeTree extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SetLocation = new armory.logicnode.SetLocationNode(this);
		var _OnUpdate = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate.property0 = "Update";
		var _Print = new armory.logicnode.PrintNode(this);
		_Print.addInput(_OnUpdate, 0);
		var _PickObject = new armory.logicnode.PickObjectNode(this);
		var _MouseCoords = new armory.logicnode.MouseCoordsNode(this);
		_MouseCoords.addOutputs([_PickObject]);
		_MouseCoords.addOutputs([new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0)]);
		_MouseCoords.addOutputs([new armory.logicnode.IntegerNode(this, 0)]);
		_PickObject.addInput(_MouseCoords, 0);
		_PickObject.addOutputs([new armory.logicnode.ObjectNode(this, "")]);
		_PickObject.addOutputs([_Print]);
		_Print.addInput(_PickObject, 1);
		_Print.addOutputs([new armory.logicnode.NullNode(this)]);
		_OnUpdate.addOutputs([_SetLocation, _Print]);
		_SetLocation.addInput(_OnUpdate, 0);
		_SetLocation.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_SetLocation.addInput(new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0), 0);
		_SetLocation.addOutputs([new armory.logicnode.NullNode(this)]);
		var _Vector = new armory.logicnode.VectorNode(this);
		var _Integer = new armory.logicnode.IntegerNode(this);
		var _SeparateXYZ = new armory.logicnode.SeparateVectorNode(this);
		_SeparateXYZ.addInput(new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0), 0);
		_SeparateXYZ.addOutputs([_Integer]);
		var _Integer_001 = new armory.logicnode.IntegerNode(this);
		_Integer_001.addInput(_SeparateXYZ, 1);
		_Integer_001.addOutputs([_Vector]);
		_SeparateXYZ.addOutputs([_Integer_001]);
		var _Integer_002 = new armory.logicnode.IntegerNode(this);
		_Integer_002.addInput(_SeparateXYZ, 2);
		_Integer_002.addOutputs([_Vector]);
		_SeparateXYZ.addOutputs([_Integer_002]);
		_Integer.addInput(_SeparateXYZ, 0);
		_Integer.addOutputs([_Vector]);
		_Vector.addInput(_Integer, 0);
		_Vector.addInput(_Integer_001, 0);
		_Vector.addInput(_Integer_002, 0);
		_Vector.addOutputs([new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0)]);
		var _SpawnObject = new armory.logicnode.SpawnObjectNode(this);
		_SpawnObject.addInput(new armory.logicnode.NullNode(this), 0);
		_SpawnObject.addInput(new armory.logicnode.ObjectNode(this, ""), 0);
		_SpawnObject.addInput(new armory.logicnode.NullNode(this), 0);
		_SpawnObject.addInput(new armory.logicnode.BooleanNode(this, false), 0);
		_SpawnObject.addOutputs([new armory.logicnode.NullNode(this)]);
		_SpawnObject.addOutputs([new armory.logicnode.ObjectNode(this, "")]);
		var _LookAt = new armory.logicnode.LookAtNode(this);
		_LookAt.addInput(new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0), 0);
		_LookAt.addInput(new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0), 0);
		_LookAt.addOutputs([new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0)]);
		var _ScreenToWorldSpace = new armory.logicnode.ScreenToWorldSpaceNode(this);
		_ScreenToWorldSpace.addInput(new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0), 0);
		_ScreenToWorldSpace.addOutputs([new armory.logicnode.VectorNode(this, 0.0, 0.0, 0.0)]);
		var _Mouse = new armory.logicnode.MergedMouseNode(this);
		_Mouse.property0 = "Down";
		_Mouse.property1 = "middle";
		_Mouse.addOutputs([new armory.logicnode.NullNode(this)]);
		_Mouse.addOutputs([new armory.logicnode.BooleanNode(this, false)]);
	}
}
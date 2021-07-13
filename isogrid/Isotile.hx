package isogrid;
import lime.app.Event;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class Isotile 
{
	public var id:Int;
	public var x:Int;
	public var y:Int;
	
	public var states:Array<EStates>;
	
	public var isDirty:Bool;

	public function new(id:Int, x:Int, y:Int) 
	{
		this.id = id;
		this.x = x;
		this.y = y;
		
		
		states = [EMPTY];
		
		isDirty = false;
	}
	
	public function add(state:EStates):Isotile
	{
		if (states.indexOf(state) == -1)
		{
			states.push(state);
			isDirty = true;
		}
		return this;
	}
	
	public function remove(state:EStates):Isotile
	{
		if (states.indexOf(state) != -1)
		{
			states.remove(state);
			isDirty = true;
		}
		return this;
	}
	
	public function update():Void
	{
		isDirty = false;
	}
	
}
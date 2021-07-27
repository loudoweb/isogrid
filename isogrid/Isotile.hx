package isogrid;
import isogrid.enums.EStates;
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
	
	public var state:EStates;
	
	public var isHover:Bool;
	
	public var isDirty:Bool;

	public function new(id:Int, x:Int, y:Int) 
	{
		this.id = id;
		this.x = x;
		this.y = y;
		
		
		state = EMPTY;
		
		isHover = false;
		isDirty = false;
	}
	
	inline public function toggleHover():Bool
	{
		isDirty = true;
		isHover = !isHover;
		return isHover;
	}
	
	public function setAlly(current:Bool = false, attackable:Bool = false, inactive:Bool = false):Void
	{

		state = ALLY(current, attackable, inactive);
		isDirty = true;
	}
	
	public function setEnemy(current:Bool = false, attackable:Bool = false, inactive:Bool = false):Void
	{

		state = ENEMY(current, attackable, inactive);
		isDirty = true;
	}
	
	public function setEmpty():Void
	{
		state = EMPTY;
		isDirty = true;
	}
	
	public function update():Void
	{
		isDirty = false;
	}
	
}
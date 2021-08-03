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
	public var indexX:Int;
	public var indexY:Int;
	
	public var x:Int;
	public var y:Int;
	
	public var state(default, set):EStates;
	public var cost:Int;
	
	public var isHover:Bool;
	
	public var isDirty:Bool;
	
	public var defaultCost:Int;

	/**
	 * 
	 * @param	id based on position in the grid
	 * @param	indexX position in the grid
	 * @param	indexY position in the grid
	 * @param	x world position
	 * @param	y world position
	 * @param	defaultCost cost of pathfinding
	 */
	public function new(id:Int, indexX:Int, indexY:Int, x:Int, y:Int, defaultCost:Int = 1) 
	{
		this.id = id;
		this.indexX = indexX;
		this.indexY = indexY;
		this.x = x;
		this.y = y;
		this.defaultCost = defaultCost;
		
		
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
	}
	
	public function setEnemy(current:Bool = false, attackable:Bool = false, inactive:Bool = false):Void
	{

		state = ENEMY(current, attackable, inactive);
	}
	
	public function set_state(_state:EStates):EStates
	{
		state = _state;
		switch(state)
		{
			case EMPTY:
				cost = defaultCost;
			case NONE:
				cost = 0;
			default:
				cost = 10;
			
		}
		isDirty = true;
		return _state;
	}
	
	public function update():Void
	{
		isDirty = false;
	}
	
}
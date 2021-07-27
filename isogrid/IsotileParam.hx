package isogrid;
import haxe.xml.Access;
import isogrid.enums.EType;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
@:generic
class IsotileParam
{
	public var img:String;
	public var width:Int;
	public var height:Int;
	public var type:EType;
	public var offsetX:Int;
	public var offsetY:Int;
	
	public var custom:IsotileCustom;

	inline public function new(img:String = "", type:EType = WALKABLE, path:String = "", ext:String = "", w:Int = 1, h:Int = 1, offsetX:Int = 0, offsetY:Int = 0) 
	{
		this.img = path + img + ext;
		this.type = type;
		this.width = w;
		this.height = h;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}
}
package isogrid;
import haxe.xml.Access;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class Helper 
{

	/**
	 * Find xml attribute or use default value
	 * @param	xml
	 * @param	name
	 * @param	defaultValue
	 * @return
	 */
	inline public static function getFloat(xml:Access, name:String, defaultValue:Float = 0.0):Float
	{
		return xml.has.resolve(name) ? Std.parseFloat(xml.att.resolve(name)) : defaultValue;
	}
	
	inline public static function getInt(xml:Access, name:String, defaultValue:Int = 0):Int
	{
		return xml.has.resolve(name) ? Std.parseInt(xml.att.resolve(name)) : defaultValue;
	}
	
	inline public static function getBool(xml:Access, name:String, defaultValue:Bool = true):Bool
	{
		return xml.has.resolve(name) ? xml.att.resolve(name) == "true" : defaultValue;
	}
	
	inline public static function getString(xml:Access, name:String, defaultValue:String = ""):String
	{
		return xml.has.resolve(name) ? xml.att.resolve(name) : defaultValue;
	}
	
}
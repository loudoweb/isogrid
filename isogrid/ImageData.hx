package isogrid;
import haxe.ds.StringMap;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class ImageData 
{
	
	public var img:String;
	public var offsetX:Int;
	public var offsetY:Int;
	
	public var state:String;
	public var transitions:StringMap<String>;

	public function new(img:String = "", path:String = "", ext:String = "", offsetX:Int = 0, offsetY:Int = 0) 
	{
		this.img = path + img + ext;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}
	
	public function addAnimationData(state:String, xml:Xml):Void
	{
		this.state = state;
		this.transitions = new StringMap<String>();
		for (att in xml.attributes())
		{
			if(att.indexOf("trans") != -1)
				this.transitions.set(att, xml.get(att));
		}
		
	}
	
}
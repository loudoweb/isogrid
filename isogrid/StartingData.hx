package isogrid;
import haxe.xml.Access;
import isogrid.enums.EType;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class StartingData
{
	public var id:String;
	public var width:Int;
	public var height:Int;
	public var type:EType;

	/**
	 * If true, this asset should be in a layer behind the tiles
	 */
	public var behind:Bool;
	
	/**
	 * If true, this asset must be have an alpha effect to show what's behind on hover
	 */
	public var alphaHover:Bool;
	
	public var images:Array<ImageData>;
		
	public function new(id:String, type:EType = WALKABLE, w:Int = 1, h:Int = 1, behind:Bool = false, alphaHover:Bool = false) 
	{
		this.id = id;
		this.type = type;
		this.width = w;
		this.height = h;
		this.behind = behind;
		this.alphaHover = alphaHover;
		images = [];
	}
	
	public function addImage(img:String = "", path:String = "", ext:String = "", offsetX:Int = 0, offsetY:Int = 0):ImageData
	{
		var image = new ImageData(img, path, ext, offsetX, offsetY);
		images.push(image);
		return image;
	}
	
}
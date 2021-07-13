package isogrid;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.xml.Access;
using isogrid.Helper;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class Isogrid 
{

	public var id:String;
	public var width:Int;
	public var height:Int;
	public var tileWidth:Int;
	public var tileHeight:Int;
	public var originX:Int;
	public var originY:Int;
	
	public var mode:EMode;
	
	
	/**
	 * Type of cells
	 */
	public var states:Map<EStates, String>;
	
	/**
	 * Describe a level.
	 */
	public var startingTiles:IntMap<IsotileParam>;
	
	/**
	 * Current state of the grid.
	 */
	public var tiles:IntMap<Isotile>;
	
	public var halfTileWidth(default, null):Int;
	public var halfTileHeight(default, null):Int;
	
	public function new(id:String, w:Int, h:Int, tileW:Int, tileH:Int, x:Int = 0, y:Int = 0, mode:EMode = STANDARD) 
	{
		this.id = id;
		this.width = w;
		this.height = h;
		this.tileWidth = tileW;
		this.tileHeight = tileH;
		this.originX = x;
		this.originY = y;
		this.mode = mode;
		
		this.states = new Map<EStates, String>();
		
		halfTileWidth = Std.int(tileWidth / 2);
		halfTileHeight = Std.int(tileHeight / 2);
		
		build();
	}
	
	function build():Void
	{
		tiles = new IntMap<Isotile>();
		for (y in 0...height)
		{
			for (x in 0...width)
			{
				switch(mode)
				{
					case STANDARD:
						tiles.set( getKey(x, y), (new Isotile(getKey(x, y), Math.round(( x - y) * halfTileWidth + originX - halfTileWidth), Math.round((y + x) * halfTileHeight + originY))));
					case STAGGERED:
						if ((y & 1) == 0)
						{
							tiles.set( getKey(x, y), new Isotile(getKey(x, y), Math.round(x * tileWidth + originX), Math.round(y * halfTileHeight + originY)));
						}else{
							tiles.set( getKey(x, y), new Isotile(getKey(x, y), Math.round(x * tileWidth + halfTileWidth + originX), Math.round(y * halfTileHeight + originY)));
						}
						
				}
				
			}
		}
	}
	
	public function getGraphic(tile:Isotile):Array<String>
	{
		var graphics = [];
		for (state in tile.states)
		{
			graphics.push(states.get(state));
		}
		return graphics;
	}
	
	public function getTileFromWorld(x:Int, y:Int):Isotile
	{
		switch(mode)
		{
			case STANDARD:
				x -= originX;
				y -= originY;
				
				var mapX = Std.int((x / halfTileWidth + y / halfTileHeight) * 0.5);
				var mapY = Std.int((y / halfTileHeight - x / halfTileWidth) * 0.5);
				return getTileFromIndex(mapX, mapY);
			case STAGGERED:
				return null;
		}
	}
	
	public function getTileFromIndex(x:Int, y:Int):Isotile
	{
		var key = getKey(x, y);
		if (tiles.exists(key))
		{
			return tiles.get(key);
		}else{
			return null;
		}
	}
	
	inline public function getKey(x:Int, y:Int):Int
	{
		return x + (y * width);
	}
	
	public static function parse(xml:Xml, path:String = "", ext:String = ""):Isogrid
	{
		var _xml = new Access(xml.firstElement());
		var world = new Isogrid(_xml.getString("id", "grid"), _xml.getInt("w"), _xml.getInt("h"), _xml.getInt("tileW"), _xml.getInt("tileH"), _xml.getInt("x"), _xml.getInt("y"), Type.createEnum(EMode, _xml.getString("mode", "STANDARD").toUpperCase()) );
		for (state in _xml.node.states.elements)
		{
			world.states.set(Type.createEnum(EStates, state.name.toUpperCase()), path + state.att.img + ext);
		}
		world.startingTiles = new IntMap<IsotileParam>();
		for (tile in _xml.node.tiles.nodes.tile)
		{
			var x = tile.getInt("x");
			var y = tile.getInt("y");
			world.startingTiles.set(x + (y * world.width), new IsotileParam(tile.getString("img")));
		}
		return world;
	}
	
}
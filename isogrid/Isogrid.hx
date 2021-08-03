package isogrid;
import haxe.Constraints.Function;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.xml.Access;
import isogrid.enums.EMode;
import isogrid.enums.EStates;
import isogrid.enums.EType;
using isogrid.Helper;
using haxe.EnumTools;

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
	public var states:Array<StringMap<String>>;
	
	/**
	 * Describe a level.
	 */
	public var startingTiles:IntMap<StartingData>;
	
	/**
	 * Current state of the grid.
	 */
	public var tiles:IntMap<Isotile>;
	
	public var pathAssets:StringMap<String>;
	
	public var halfTileWidth(default, null):Int;
	public var halfTileHeight(default, null):Int;
	
	var _map:Array<Int>;
	
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
		
		this.states = new Array<StringMap<String>>();
		this.startingTiles = new IntMap<StartingData>();
		this.pathAssets = new StringMap<String>();
		
		
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
				var key = getKey(x, y);
				switch(mode)
				{
					case STANDARD:
						tiles.set( key, (new Isotile(key, x, y, Math.round(( x - y) * halfTileWidth + originX - halfTileWidth), Math.round((y + x) * halfTileHeight + originY))));
					case STAGGERED:
						if ((y & 1) == 0)
						{
							tiles.set( key, new Isotile(key, x, y, Math.round(x * tileWidth + originX), Math.round(y * halfTileHeight + originY)));
						}else{
							tiles.set( key, new Isotile(key, x, y, Math.round(x * tileWidth + halfTileWidth + originX), Math.round(y * halfTileHeight + originY)));
						}
						
				}
				
			}
		}
	}
	
	/**
	 * This could be overided to change the tiles to draw (quantity, order, etc.)
	 * @param	tile
	 * @return
	 */
	public function getGraphics(tile:Isotile):Array<String>
	{
		var graphics = [];
		var enumIndex = tile.state.getIndex();
		switch(tile.state)
		{
			case NONE:
				return null;
			case ACTION, NEUTRAL:
				graphics.push(states[enumIndex].get('img'));
			case EMPTY:
				
				if (tile.isHover)
				{
					graphics.push(states[enumIndex].get('hover'));
				}else{
					graphics.push(states[enumIndex].get('img'));
				}
				return graphics;
			case ALLY(current, attackable, inactive):
				if (inactive)
				{
					graphics.push(states[enumIndex].get('inactive'));
				}
				if (attackable)
				{
					graphics.push(states[enumIndex].get('attackable'));
				}
				if (current)
				{
					graphics.push(states[enumIndex].get('current'));
				}else{
					graphics.push(states[enumIndex].get('img'));
				}
				
			case ENEMY(current, attackable, inactive):
				if (inactive)
				{
					graphics.push(states[enumIndex].get('inactive'));
				}
				if (attackable)
				{
					graphics.push(states[enumIndex].get('attackable'));
				}
				if (current)
				{
					graphics.push(states[enumIndex].get('current'));
				}else{
					graphics.push(states[enumIndex].get('img'));
				}
		}
		
		
		return graphics;
	}
	
	public function getStartingGraphics(tile:Isotile):StartingData
	{
		if (startingTiles.exists(tile.id))
		{
			return startingTiles.get(tile.id);
		}
		return null;
		
		
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
				if (mapX < 0 || mapY < 0 || mapX >= width || mapY >= height)
					return null;

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
		
	/**
	 * Use with Graph.setWorld() haxelib astar
	 * @return
	 */
	public function getMap():Array<Int>
	{
		if (_map == null)
			_map = [];
		else
			_map.splice(0, _map.length);
			
		for (tile in tiles)
		{
			_map[tile.id] = tile.cost;
		}
		
		//TODO isDirty flag to return cache?
		return _map;
	}
	
	
	public static function parse(xml:Xml, path:String = "", ext:String = ""):Isogrid
	{
		var _xml = new Access(xml.firstElement());
		var world = new Isogrid(_xml.getString("id", "grid"), _xml.getInt("w"), _xml.getInt("h"), _xml.getInt("tileW"), _xml.getInt("tileH"), _xml.getInt("x"), _xml.getInt("y"), Type.createEnum(EMode, _xml.getString("mode", "STANDARD").toUpperCase()) );
		for (state in _xml.node.states.elements)
		{
			var stateName = state.name.toUpperCase();
			
			try
			{
				var stateParam = null;
				if (stateName == "ALLY" || stateName == "ENEMY")
				{
					stateParam = [false, false, false];
				}
				
				var estate = Type.createEnum(EStates, stateName, stateParam );
				var stateIndex = estate.getIndex();
				
				var attributes = new StringMap<String>();
				for (att in state.x.attributes() )
				{
					attributes.set(att, path + state.att.resolve(att) + ext);
				}
				world.states[stateIndex] = attributes;
			}catch (e)
			{
				trace('ENUM EStates $stateName doesn\'t exist');
			}
			
		}
		
		if (_xml.hasNode.path)
		{
			var pathAccess = _xml.node.path;
			for (att in pathAccess.x.attributes())
			{
				world.pathAssets.set(att, path + pathAccess.att.resolve(att) + ext); 
			}
		}

		for (tile in _xml.node.tiles.nodes.tile)
		{
			var x = tile.getInt("x");
			var y = tile.getInt("y");
			var id = x + (y * world.width);
			var type = Type.createEnum(EType, tile.getString("type", "walkable").toUpperCase());
			var w = tile.getInt("w", 1);
			var h = tile.getInt("h", 1);
			var starting = new StartingData(tile.getString("id"), type, w, h, tile.getBool("behind", false), tile.getBool("alphaHover", false));
			for (img in tile.nodes.img)
			{
				var offsetX = img.getInt("offsetX");
				var offsetY = img.getInt("offsetY");
				var image = starting.addImage(img.getString("name"), path, ext, offsetX, offsetY);
				image.addAnimationData(img.getString("state"), img.x);
			}
			world.startingTiles.set(id, starting);
			
			
			
			if (type == UNWALKABLE)
			{
				for (i in x...x + w)
				{
					for (j in y...y + h)
					{
						world.getTileFromIndex(i, j).state = NONE;
					}
				}
			}
		}
		return world;
	}
	
}
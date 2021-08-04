# isogrid

Create a dimetric grid (2:1 isometric). Store type of tile for you (empty tile, attackable, ennemy...) and return all images associated with it. 
Add default game objects to your level. Describe a game object with one or more images and store transition in and out.

## XML

You can describe your grid with a xml.

```
<isogrid w="8" h="8" tileW="171" tileH="87" x="0" y="0">
	<!-- these describes the images needed to represent the state of the tile -->
	<states>
		<empty img="grid/tile-empty" hover="grid/tile-empty-hover" />
		
		<ally img="grid/team"  current="grid/player-selected-turn" inactive="grid/inactive" />
		<enemy img="grid/ennemy" attackable="grid/attack" inactive="grid/inactive"/>

		<neutral img="grid/neutral"/>
		<action img="grid/action"/>
	</states>
	
	<!-- these describes the images needed to show a path (with pathfinding) -->
	<path start="grid/mvt-start" footprint="grid/mvt-path" destination="grid/mvt-goal" arrow="grid/mvt-arrow"/>
	
	<!-- these describes the images needed to draw a game object, could be extended with kadabra-states and kadabra-anims -->
	<tiles>
		<tile id="machine" x="3" y="3" w="2" h="2" type="unwalkable" alphaHover="true">
			<img name="machine" offsetY="-15" alpha="0.5" />
			<img name="machine_anim_loop" offsetX="1" offsetY="-37"  transin="breathe_Alpha"/>
			<img name="machine_anim_pulse" state="pulse" offsetX="5" offsetY="2" visible="false" transin="spreadout"/>
		</tile>
		<tile x="1" y="6" type="unwalkable">
			<img name="rock"/>
		</tile>
	</tiles>
</isogrid>
```

## extend

The default engine returns a certain stacks of images depending of the states of your tiles. You could extend it to stack differently or returns only one image.

## dependency

https://github.com/loudoweb/kadabra-utils
	
## other

There is default method that returns an array compatible with [astar](https://gitlab.com/haath/astar)
	
You could use in conjonction with [kadabra-states](https://github.com/loudoweb/kadabra-states) to have statable element and [kadaba-anims](https://github.com/loudoweb/kadabra-anims) to animate transition of those states.
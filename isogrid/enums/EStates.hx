package isogrid.enums;

/**
 * @author Ludovic Bas - www.lugludum.com
 */
enum EStates 
{
	NONE;
	
	EMPTY;

	ACTION;
	
	NEUTRAL;
	
	ALLY(current:Bool, attackable:Bool, inactive:Bool);
	
	ENEMY(current:Bool, attackable:Bool, inactive:Bool);
	
}
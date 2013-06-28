package com.intuitStudio.motions.biDimen.IF 
{
	import com.intuitStudio.motions.biDimen.core.Vector2D;
	
	/**
	 * Interface IMovable
	 * @author vanier peng , 2013.03.02
	 * Purpose : 定義物體移動的操作界面 
	 *
	 */
	public interface IMovable 
	{
		function get location():Vector2D;
		function set location(v2:Vector2D):void;
		function get velocity():Vector2D;
		function set velocity(v2:Vector2D):void;
		function get accelation():Vector2D;
		function set accelation(v2:Vector2D):void;
		function get maxSpeed():Number;
		function set maxSpeed(value:Number):void;		
		function get edgeAct():int;
		function set edgeAct(typeId:int):void;
		function applyBounce():void;
		function applyWrap():void;
		function update(elapsed:Number = 1.0):void;
		function rendering():void;
	}
	
}
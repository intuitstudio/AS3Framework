package com.intuitStudio.triMotion.core 
{	
	/**
	 * Point3d Class
	 * @author vanier peng,2013.4.20
	 * 定義基本3d空間的點物件，賦與基本的座標、質量、尺寸等屬性
	 */
	import com.intuitStudio.triMotion.core.Perspective;
    import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	
	public class Point3d extends Vector3D
	{
		private var _tx:Number;
		private var _ty:Number;
		private var _tz:Number;
		private var _mass:Number = 1.0;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _depth:Number = 0;
		private var _perspective:Perspective;
		private var _visible:Boolean = true;
		
		public function Point3d(xpos:Number = 0, ypos:Number = 0,zpos:Number = 0) 
		{
			super(xpos, ypos, zpos);
			bufferPoint = new Vector3D(x,y,z);
		}
		
		public function get tx():Number
		{
			return _tx;
		}
		
		public function set tx(value:Number):void
		{
			_tx = value;
		}

		public function get ty():Number
		{
			return _ty;
		}

		public function set ty(value:Number):void
		{
			_ty = value;
		}

		public function get tz():Number
		{
			return _tz;
		}
		
		public function set tz(value:Number):void
		{
			_tz = value;
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}

		public function get bufferPoint():Vector3D
		{
			return new Vector3D(tx,ty,tz);
		}
		
		public function set bufferPoint(point:Vector3D):void
		{
			tx = point.x;
			ty = point.y;
			tz = point.z;
		}	
		
		public function get mass():Number
		{
			return _mass;			
		}
		
		public function set mass(value:Number):void
		{
			_mass = value;
		}
		
		public function get perspective ():Perspective
		{
			return _perspective;
		}
		
		public function set perspective (pp:Perspective):void
		{
			_perspective = pp;
		}
		
		public function makePerspective ():Number {
		   if (perspective === null) { perspective = new Perspective(); }	
			
		   visible = (z > -perspective.fl);
           return perspective.fl/(perspective.fl+z+perspective.centerZ);		
	    } 
	
	    public function get screenX():Number{	
		   var scale:Number = makePerspective();
		   return perspective.vanishingPoint.x+(perspective.centerX + x)*scale;
	    } 
	
	    public function get screenY():Number{	
		   var scale:Number = makePerspective();
		   return perspective.vanishingPoint.y+(perspective.centerY+y)*scale;
	    } 
		
		public function rendering(context:DisplayObject=null):void
		{
			draw(context);
		}
		
		// 繪製示意用的圓點
		protected function draw(context:DisplayObject):void
		{
			if (context.hasOwnProperty('graphics'))
			{
				var radius:Number = 40;
				var color:uint = 0x000000;
				var gs:Graphics;
				context.x = screenX;
				context.y = screenY;
			    radius *= makePerspective();
				if (context is Sprite) {
				  // context.x = x;
				   //context.y = y;
				  // context.z = z;
					gs = Sprite(context).graphics;
				}
				if (context is Shape)
				{				  
					gs = Shape(context).graphics;
				}
				if(gs){
				   with (gs)
				   {
					  clear();
					  lineStyle(0);
					  beginFill(color);
					  drawCircle( -(radius >> 1), -(radius >> 1), radius);
					  endFill(); 
				   }				   
				}
			}
		}
		
	}

}
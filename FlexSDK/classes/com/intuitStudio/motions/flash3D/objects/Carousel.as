package com.intuitStudio.motions.flash3D.objects
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import com.intuitStudio.motions.flash3D.core.Point3D;
	import com.intuitStudio.motions.flash3D.core.Vehicle3D;
	import com.intuitStudio.motions.flash3D.core.Shape3D;
	import com.intuitStudio.framework.managers.RegisterObject;
	import com.intuitStudio.framework.abstracts.ShaderColor;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.utils.VectorUtils;
	import com.intuitStudio.utils.ColorUtils;

	public class Carousel extends Vehicle3D
	{
		private var _radius:Number;
		private var _numItems:int = 5;
		private var _size:Number;
		protected var _color:ShaderColor;
		private var _blend:Number;

		public function Carousel (size:Number,radius:Number,count:Number= 5,openness:Number = 1.0)
		{
			_size = size;
			_radius = radius;
			_numItems = count;
			_blend = openness;
			super ();
		}

        override protected function init():void
	    {			
		   super.init();
		  
		   draw();
	    }
	   
		private function makeCarousel ():void
		{
			for (var i:uint=0; i<_numItems; i++)
			{
				var angle:Number = Math.PI * 2 / _numItems * i;
				var transAngle:Number = -360 / _numItems * i + 90;
				var item:Vehicle3D = makeItem(i,angle,transAngle);
				addChild (item,'item_'+i);
				item.update();
				item.render();
			}
		}

		//override by sub class, default is create shape3D objects
		protected function makeItem (index:int,angle:Number,transAngle:Number):Vehicle3D
		{
			var container:Vehicle3D = new Vehicle3D();
			if(_color == null)
			{
				_color = new ShaderColor(Math.random());
			}
			var shape:Shape3D = new Shape3D(_size,_color,_blend);
			shape.render ();
			//
			var translate:Vector3D = new Vector3D();
			translate.x = Math.cos(angle) * radius;
			translate.y = 250;
			translate.z = Math.sin(angle) * radius;
			var rotate:Vector3D = new Vector3D(0,transAngle,0);
			var scale:Vector3D = new Vector3D(1,1,1);
			shape.makeTransform (translate,rotate,scale);					
			//		
			container.addChild (shape,'childShape');
			addChild (shape,'shape_'+index,false);            
			return container;
		}

		override protected function doDraw ():void
		{
			makeCarousel();
			//sortZ ();
		}

		public function set size (value:Number):void
		{
			_size = value;
			_updateView++;
		}

		public function get size ():Number
		{
			return _size;
		}

		public function set color (value:int):void
		{
			_color.color = value;
			_updateView++;
		}

		public function get color ():int
		{
			return _color.color;
		}

		public function set length (value:int):void
		{
			_numItems = value;
			_updateView++;
		}

		public function get length ():int
		{
			return _numItems;
		}
		public function set radius (value:Number):void
		{
			_radius = value;
			_updateView++;
		}

		public function get radius ():Number
		{
			return _radius;
		}

		override public function update (elapsed:Number = 1.0):void
		{
			sortZ ();
		}

		override public function render ():void
		{
			if (_updateView > 0)
			{
				for (var i:uint=0;i<_numItems;i++)
				{
					var obj:Vehicle3D = _register.getObjectByName('item_'+i) as Vehicle3D;
					obj.render();
				}
				super.render();
				_updateView = 0;
			}

		}
	}

}
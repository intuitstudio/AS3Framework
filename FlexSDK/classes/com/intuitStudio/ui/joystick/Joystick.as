package com.intuitStudio.ui.joystick
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;

	public class Joystick extends Sprite
	{
		private var stickName:Class;
		private var knobName:Class;
		private var instance:MovieClip;
		private var marginX:Number;
		private var marginY:Number;
		private var xpos:Number = 0;
		private var ypos:Number = 0;

		private var knob:JoystickKnob;
		private var knobMovements:Dictionary;
		private var knob_tween:TweenLite;
		public var pulling:Boolean = false;
		public var disabled:Boolean = false;


		public function Joystick (stickId:Class,knobId:Class,marginLeft:Number,marginBottom:Number)
		{
			stickName = stickId;
			knobName = knobId;
			marginX = marginLeft;
			marginY = marginBottom;
			//

			if (stage)
			{
				init ();
			}
			else
			{
				addEventListener (Event.ADDED_TO_STAGE,init);
			}
		}

		private function init (e:Event = null):void
		{
			if (e)
			{
				removeEventListener (Event.ADDED_TO_STAGE,init);
			}

			knobMovements = new Dictionary();
			knobMovements['left'] = 0;
			knobMovements['right'] = 0;
			knobMovements['up'] = 0;
			knobMovements['down'] = 0;

			draw ();
			disable = false;

		}

		protected function draw ():void
		{
			instance = new stickName() as MovieClip;
			addChild (instance);

			knob = new JoystickKnob(knobName);
			knob.x = 0;
			knob.y = 0;
			knob.originX = 0;
			knob.originY = 0;
			addChild (knob);
			knob.buttonMode = true;
			//
			px = marginX + this.width / 2;
			py = stage.stageHeight - marginY - this.height / 2;			
			 
			render ();
			 
		}

		public function locate (locx:Number,locy:Number):void
		{
			px = locx;
			py = locy;
			render ();
		}

		public function get wild ():Number
		{
			return instance.width;
		}

		public function get tall ():Number
		{
			return instance.height;
		}

		public function set px (value:Number):void
		{
			xpos = value;
		}

		public function get px ():Number
		{
			return xpos;
		}

		public function set py (value:Number):void
		{
			ypos = value;
		}

		public function get py ():Number
		{
			return ypos;
		}

		public function render ():void
		{
			x = xpos;
			y = ypos;
		}

		private function mouseDown (event:MouseEvent):void
		{
			if (knob_tween)
			{
				knob_tween.kill ();
			}
			pulling = true;
			addEventListener (Event.ENTER_FRAME, knobMoved);
			knob.startDrag (false,new Rectangle( -  instance.width / 2, -  instance.height / 2,instance.width,instance.height));
		}

		private function joystickReleased (event:MouseEvent):void
		{
			knob.stopDrag ();
			pulling = false;
			if (this.hasEventListener(Event.ENTER_FRAME))
			{
				this.removeEventListener (Event.ENTER_FRAME, knobMoved);
			}
			//
			mover ();
			knobMovements['right'] = 0;
			knobMovements['left'] = 0;
			knobMovements['up'] = 0;
			knobMovements['down'] = 0;
		}

		private function snapKnob (event:MouseEvent):void
		{
			knob.x = this.mouseX;
			knob.y = this.mouseY;
			mouseDown (null);
		}

		private function knobMoved (event:Event):void
		{
			// LEFT OR RIGHT
			var halfSqare:Number = 20;

			if (knob.x > halfSqare)
			{
				knobMovements['right'] = knob.x - halfSqare;
				knobMovements['left'] = 0;
			}
			else if (knob.x < -halfSqare)
			{
				knobMovements['right'] = 0;
				knobMovements['left'] = knob.x + halfSqare;
			}
			else
			{
				knobMovements['right'] = 0;
				knobMovements['left'] = 0;
			}

			// UP OR DOWN
			if (knob.y > halfSqare)
			{
				knobMovements['up'] = 0;
				knobMovements['down'] = knob.y - halfSqare;
			}
			else if (knob.y < -halfSqare)
			{
				knobMovements['up'] = knob.y + halfSqare;
				knobMovements['down'] = 0;
			}
			else
			{
				knobMovements['up'] = 0;
				knobMovements['down'] = 0;
			}
		}

		private function mover ():void
		{

			knob_tween = new TweenLite(knob,0.5,{x:knob.originX,y:knob.originY,ease:Bounce.easeOut});
		}

		public function getPullH ():Number
		{
			return knobMovements['left'] +knobMovements['right'];
		}
		public function getPullV ():Number
		{
			return knobMovements['up'] +knobMovements['down'];
		}

		public function set disable (valid:Boolean):void
		{
			disabled = valid;
			if (! disabled)
			{
				knob.buttonMode = true;
				this.addEventListener (MouseEvent.MOUSE_DOWN, snapKnob);
				knob.addEventListener (MouseEvent.MOUSE_DOWN, mouseDown);
				this.parent.addEventListener (MouseEvent.MOUSE_UP, joystickReleased);
			}
			else
			{
				knob.buttonMode = false;
				if (this.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					this.removeEventListener (MouseEvent.MOUSE_DOWN, snapKnob);
				}
				if (knob.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					knob.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDown);
				}
				if (this.parent.hasEventListener(MouseEvent.MOUSE_UP))
				{
					this.parent.removeEventListener (MouseEvent.MOUSE_UP, joystickReleased);
				}
			}
		}

		public function get disable ():Boolean
		{
			return disabled;
		}
	}
}
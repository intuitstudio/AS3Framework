package com.intuitStudio.motions.triDimens.isometric.concretes
{
	import com.intuitStudio.motions.triDimens.isometric.IsoUtils;
	import com.intuitStudio.motions.triDimens.isometric.core.DrawnIsoTile;
	import com.intuitStudio.utils.ColorUtils;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.ColorTransform;

	public class DrawnIsoBox extends DrawnIsoTile
	{
		public static const TOP:String = "topFace";
		public static const LEFT:String = "leftFace";
		public static const RIGHT:String = "rightFace";
		private var topFace:Shape;
		private var leftFace:Shape;
		private var rightFace:Shape;
		private var topOffset:Number = 1;
		private var leftOffset:Number = .5;
		private var rightOffset:Number = .8;

		public function DrawnIsoBox (size:Number,col:uint,h:Number=0)
		{
			super (size,col,h);
		}

		override public function draw ():void
		{
			graphics.clear ();

			var topShadow:uint = ColorUtils.darker(color,topOffset);
			var leftShadow:uint = ColorUtils.darker(color,leftOffset);
			var rightShadow:uint = ColorUtils.darker(color,rightOffset);
			var h:Number = tall * IsoUtils.yModifier;
			
			topFace = drawFace(TOP,topShadow,h);
			leftFace = drawFace(LEFT,leftShadow,h);
			rightFace = drawFace(RIGHT,rightShadow,h);
			addChild (topFace);
			addChild (leftFace);
			addChild (rightFace);
		}

		private function drawFace (theFace:String,color:uint,h:Number):Shape
		{
			var face:Shape = new Shape();
			var g:Graphics = face.graphics;
			g.beginFill (color);
			g.lineStyle (0,0,.1);

			var commands:Vector.<int> = new Vector.<int>();
			commands.push (GraphicsPathCommand.MOVE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);

			var data:Vector.<Number> = new Vector.<Number>();
			switch (theFace)
			{
				case TOP :
					data.push (-size,-h);
					data.push (0,-size*.5-h);
					data.push (size,-h);
					data.push (0,size*.5-h);
					data.push (-size,-h);
					break;
				case LEFT :
					data.push (-size,-h);
					data.push (0,size*.5-h);
					data.push (0,size*.5);
					data.push (-size,0);
					data.push (-size,-h);

					break;
				case RIGHT :
					data.push (size,-h);
					data.push (0,size*.5-h);
					data.push (0,size*.5);
					data.push (size,0);
					data.push (size,-h);

					break;
				default :

			}
			g.drawPath (commands,data);
			g.endFill ();
			return face;
		}

		public function changeFaceColor (faceType:String,col:uint):void
		{
			switch (faceType)
			{
				case TOP :
				    var shadow:uint = ColorUtils.darker(col,topOffset);
					break;
				case LEFT :
				    shadow = ColorUtils.darker(col,leftOffset); 
					break;
				case RIGHT :
				    shadow = ColorUtils.darker(col,rightOffset);
					break;
			}

			Shape(this[faceType]).transform.colorTransform = ColorUtils.colorTransform(shadow);
		}
		
		public function changeBoxColor(col:uint):void
		{
			changeFaceColor(TOP,col);
			changeFaceColor(LEFT,col);
			changeFaceColor(RIGHT,col);
		}

	}
}
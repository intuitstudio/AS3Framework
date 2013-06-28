package com.intuitStudio.motions.flash3D.objects
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.geom.Vector3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;

	import com.intuitStudio.motions.flash3D.core.Point3D;
	import com.intuitStudio.motions.flash3D.core.Vehicle3D;
	import com.intuitStudio.motions.flash3D.core.Shape3D;
	import com.intuitStudio.framework.abstracts.ShaderColor;
	import com.intuitStudio.utils.VectorUtils;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.Vector3DUtils;


	public class Room extends Box
	{
		public function Room (size:Number,color:ShaderColor,openness:Number=1.0)
		{
			super (size,color,openness);
		}
		
		override protected function initPaints (coloring:ShaderColor):void
		{
			//trace ('init pain color');
			_colors = new Dictionary();
			setFacePaint (Box.FACE_TOP, new ShaderColor(0x00FFFF));
			setFacePaint (Box.FACE_BOTTOM, new ShaderColor(0x000000));
			setFacePaint (Box.FACE_LEFT, new ShaderColor(0xFFFF00));
			setFacePaint (Box.FACE_RIGHT, new ShaderColor(0xFFAA00));
			setFacePaint (Box.FACE_FORE, new ShaderColor(0xFFFFFF));
			setFacePaint (Box.FACE_BACK, new ShaderColor(0xFF00FF));
		}
		
		override public function draw():void
		{
			trace('call draw by room')
			super.doDraw();			
			doDraw();
		}
		
		override protected function doDraw():void
		{
			showWall(Box.FACE_FORE,false);
		}

        override public function paintColors(coloring:ShaderColor):void
		{
			 makeShadows (lightAngle);
			//
			paintWallColor(Box.FACE_TOP,coloring);
			paintWallColor(Box.FACE_BOTTOM,coloring);
			paintWallColor(Box.FACE_LEFT,coloring);
			paintWallColor(Box.FACE_RIGHT,coloring);
			paintWallColor(Box.FACE_FORE,coloring);
			paintWallColor(Box.FACE_BACK,coloring);			
		}

        private function paintStarSky():void
		{
			
		}

	}

}
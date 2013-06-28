package com.intuitStudio.projects.common.garden.builder.abstracts
{
	import com.intuitStudio.scriptGraphics.stemGenerate.interfaces.IStem;
	import com.intuitStudio.scriptGraphics.stemGenerate.abstracts.AbstractStemCluster;
	import com.intuitStudio.scriptGraphics.stemGenerate.factories.abstracts.StemClusterFactory;
	import com.intuitStudio.scriptGraphics.stemGenerate.concretes.Bamboo;
	import com.intuitStudio.scriptGraphics.stemGenerate.concretes.Jasmine;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.errors.IllegalOperationError;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.BlendMode;
	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	import flash.display.Sprite;

	public class StemClusterBuilder extends AbstractDisplayBuilder
	{
		private var _plant:AbstractStemCluster;
		protected var _factory:StemClusterFactory;
		protected var _plantsVec:Vector.<IStem > ;


		public function StemClusterBuilder (top:DisplayObjectContainer)
		{
			super (top);
			_plantsVec = new Vector.<IStem>();
		}

		final public function createStemCluster (rect:Rectangle,type:int=0):void
		{
			_plant = AbstractStemCluster(doCreateStemCluster(type));
			rect = new Rectangle(rect.x,rect.y,_plant.clusterWild*2,_plant.tall);
			addTile( new Bitmap(_factory.snapshot().clone()),rect);
		}

		protected function doCreateStemCluster (type:int):IStem
		{
			throw new IllegalOperationError('doCreateStemCluster must be overridden');
			return null;
		}

	}


}
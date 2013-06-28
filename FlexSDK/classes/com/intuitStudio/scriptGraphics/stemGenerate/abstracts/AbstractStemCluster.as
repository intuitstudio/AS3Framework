package com.intuitStudio.scriptGraphics.stemGenerate.abstracts
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;

	import com.intuitStudio.scriptGraphics.stemGenerate.interfaces.IStem;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;

	public class AbstractStemCluster extends Sprite implements IStem
	{
		protected var _top:DisplayObjectContainer;
		protected var _content:Sprite = new Sprite();
		//number of separae plants
		protected var branches:int;
		//x,y location
		protected var xLoc:Number = 0;
		protected var yLoc:Number = 0;
		//
		protected var _clusterWild:Number;
		protected var segments:int;
		protected var leaves:int;
		protected var segmentGap:Number = 5;
		protected var modifierSegmentWidth:Number = 0.007;
		protected var leafxScale:Number = .30;
		protected var leafyScale:Number = .10;

		protected var BranchClass:Class;
		protected var LeafClass:Class;

		private var branchArray:Vector.<MovieClip > ;
		private var segmentsArray:Vector.<MovieClip > ;
		private var leavesArray:Vector.<MovieClip > ;

		private var abranch:MovieClip;
		private var asegment:MovieClip;
		private var aleaf:MovieClip;
		protected var xlocations:Array;
		protected var ylocations:Array;
		protected var colorTrans:ColorTransform;
		protected var colorFilter:ColorMatrixFilter;

		public function AbstractStemCluster (top:DisplayObjectContainer,wild:Number,stems:int=30,pieces:int=13)
		{
			_top = top;
			clusterWild = wild;
			branches = stems;
			leaves = pieces;
			branchArray = new Vector.<MovieClip>();
			segmentsArray = new Vector.<MovieClip>();
			leavesArray = new Vector.<MovieClip>();
			//_top.addChild (this);
			addChild (_content);
		}

		public function get location ():Point
		{
			return new Point(xLoc,yLoc);
		}

		public function set location (loc:Point):void
		{
			xLoc = loc.x;
			yLoc = loc.y;
			_content.x = xLoc;
			_content.y = yLoc;
		}

		final public function plant (px:Number,py:Number):void
		{
			location = new Point(px,py);
			doPlant ();
		}

		final public function chop ():void
		{
			doChop ();
		}

		protected function doPlant ():void
		{
			for (var i:int=0; i<branches; i++)
			{
				abranch = drawBranch();
				_content.addChild (abranch);
				//
				doInitSegment ();
				doInitLocation ();
				for (var j:int=0; j<segments; j++)
				{
					asegment = drawSegment(j);
					abranch.addChild (asegment);
					segmentsArray.push (asegment);
				}

				for (j=0; j<leaves; j++)
				{
					aleaf = drawLeaf(j);
					changeLeafColor (aleaf);
					abranch.addChild (aleaf);
					leavesArray.push (aleaf);
				}
				branchArray.push (abranch);
			}
			//
		}

		protected function doInitSegment ():void
		{
			segments = 30 + Math.floor(Math.random() * 40);
		}
		private function doInitLocation ():void
		{
			//
			xlocations = new Array();
			ylocations = new Array();
			xlocations[0] = 0;
			ylocations[0] = 0;
			for (var j:int=1; j<=segments; j++)
			{
				ylocations[j] =  -  segmentGap * j;
				xlocations[j] = xlocations[j-1] + j*modifierSegmentWidth*(Math.random()*21-10);
			}
		}

		//branches are spread out of center point (0,0) , and the max wild is equal to two times of _clusterWild
		//枝幹的生成邏輯是以中心點(物件_content所在)向上生長、向兩旁隨機展開的模式 ;
		//相關的工廠類別提供了點陣圖複製的方法，取其最大可能範圍
		//另外應用的Builder物件所提供的定位函式addTile，注意其對應的點陣圖位置其實是相對於左上角位置	
		protected function drawBranch ():MovieClip
		{
			var branch:MovieClip = new MovieClip();
			//center-bottom
			var randx:Number = Math.random() * 2 * _clusterWild - _clusterWild;
			var leafwide:Number = (new LeafClass()).width*.5;

			branch.x = (randx>0)?randx-leafwide:randx+leafwide;

			//left-bottom
			//branch.x = Math.random() * 2 * _clusterWild;
			branch.y = 0;
			return branch;
		}

		protected function drawSegment (id:int):MovieClip
		{
			var segment:MovieClip = new BranchClass() as MovieClip;
			segment.x = xlocations[id];
			segment.y = ylocations[id];
			segment.scaleX = (xlocations[id+1] - xlocations[id]) * .01;
			segment.scaleY = (ylocations[id+1] - ylocations[id]) * .01;
			return segment;
		}

		protected function drawLeaf (id:int):MovieClip
		{
			var leaf:MovieClip = new LeafClass() as MovieClip;
			leaf.x = xlocations[segments - 2 * id];
			leaf.y = ylocations[segments - 2 * id];
 
			leaf.scaleX = leafxScale + .01 * id;
			leaf.scaleY = leafyScale + .01 * id;
			leaf.rotation = Math.random() * 180 - 180;
			//            
			return leaf;
		}

		private function changeLeafColor (leaf:MovieClip):void
		{
			colorTrans = new ColorTransform();
			colorTrans.greenMultiplier = .70 + Math.random() * .30;
			leaf.transform.colorTransform = colorTrans;
			colorTrans = null;
		}

		protected function doChop ():void
		{
			for (var i:int=branchArray.length-1; i>=0; i--)
			{
				abranch = branchArray[i];
				for (var j:int=leavesArray.length-1; j>=0; j--)
				{
					abranch.removeChild (leavesArray[j]);
					leavesArray[j] = null;
				}

				for (j=segmentsArray.length-1; j>=0; j--)
				{
					abranch.removeChild (segmentsArray[j]);
					segmentsArray[j] = null;
				}
				removeChild (abranch);
				branchArray[i] = null;
			}
			//
			branchArray = null;
			leavesArray = null;
			branchArray = null;
			_top.removeChild (this);
		}

		public function get wild ():Number
		{
			return this.width;
		}

		public function get tall ():Number
		{
			return this.height;
		}

		public function get clusterWild ():Number
		{
			return _clusterWild;
		}

		public function set clusterWild (value:Number):void
		{
			_clusterWild = value;
		}

		public function get content ():DisplayObject
		{
			return _content;
		}

	}



}
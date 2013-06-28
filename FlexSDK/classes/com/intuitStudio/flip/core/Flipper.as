package com.intuitStudio.flip.core
{
	/**
	 * Flipper
	 * @author vanier peng,2013.4.24
	 * 定義翻頁操做容器 : 基本上分成左右兩頁所組成
	 *
	 */
	
	import com.intuitStudio.biMotion.core.Point2d;
	import com.intuitStudio.biMotion.core.Vector2d;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.intuitStudio.biMotion.core.BaseParticle;
	import com.intuitStudio.patterns.Observer.interfaces.*;
	import com.intuitStudio.kinematics.core.IK;
	import com.intuitStudio.flip.abstracts.*;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.VectorUtils;
	
	import aeon.animators.Tweener;
	import aeon.easing.Sine;
	
	public class Flipper extends BaseParticle
	{
		
		private const maxShadowWidth:int = 100;
		
		private var _canvasData:BitmapData;
		private var _canvas:Bitmap;
		private var _bufferData:BitmapData;
		private var _drawingShape:Shape;
		private var _smoothing:Boolean = true;
		
		//計算IK運動的實體
		private var _ik:IK;
		//記錄IK運動的軌跡群
		private var _locus:Vector.<Point>;
		private var _tracker:BaseParticle;
		//半圓軌跡物件，用來當做IK運動軌跡的參照
		private var _scl:SemicircleLocus;
		private var _sclContainer:Shape = new Shape();
		
		//新增sprite實體容器用來包裝影像切片，可以修正單純用Bitmap重繪切片時容易產生隙縫的問題		
		private var sliceContainer:Sprite;
		private var _sliceImages:Vector.<SlicePiece>;
		private var _sliceNum:uint = 7;
		private var _shadowR:PageShadow;
		private var _shadowL:PageShadow;
		private var _color:uint = 0xFFFFFF;
		
		private var _followPoint:Point2d;
		private var _pageFront:Sprite;
		private var _pageBack:Sprite;
		
		private var rpArr:Array; //記錄原始的SlicePiece座標位置
		private var pArr:Vector.<Point2d>; //記錄SlicePiece的變化位置
		private var yScale:Number = .3;
		
		public function Flipper(w:Number, h:Number, bufferW:Number, bufferH:Number,soft:Number=.988, shadowed:Boolean = true)
		{
			super();
			setSize(w, h);
			makeDrawingCad(bufferW, bufferH);
			yScale = soft;
			init();
			if (shadowed)
			{
				addLeftShadow();
				addRightShadow();
			}
		}
		
		protected function init():void
		{
			_pageFront = new Sprite();
			_pageBack = new Sprite();
			sliceContainer = new Sprite();

			locus = new Vector.<Point>();
			tracker = new BaseParticle();
			scl = new SemicircleLocus(width * 0.998, yScale);
			fp = new Point2d();
		}
		
		private function makeDrawingCad(bufferW:Number, bufferH:Number):void
		{
			bufferData = new BitmapData(bufferW, bufferH);
			bitmapData = bufferData.clone();
			bitmap = new Bitmap(_canvasData);
			drawingBuffer = new Shape();
		}
		
		public function setup(partA:DisplayObject, partB:DisplayObject, pieces:Number = 7):void
		{
			//remove existed content  
			if (sliceContainer.numChildren > 0)
			{
				sliceContainer.removeChildren();
			}
			
			if (_pageFront.numChildren > 0)
			{
				_pageFront.removeChildren();
			}
			
			if (_pageBack.numChildren > 0)
			{
				_pageBack.removeChildren();
			}
			
			//add new 
			_pageFront.addChild(partA);
			partB.x = partB.width;
			partB.scaleX = -1;
			_pageBack.addChild(partB);
			
			createSlices(_pageFront, _pageBack, pieces);
		}
		
		//
		override public function update(elapsed:Number = 1.0):void
		{
			moveSlices(elapsed);
		}
		
		/**
		 * when release flipp ,roll to origin position
		 */
		
		public function rollBack():void
		{
			for (var j:int = 0; j < slices.length; j++)
			{
				var sp:SlicePiece = slices[slices.length - 1 - j];
				sp.transform.matrix = sp.oriMatrix;
				sp.x = rpArr[j].x;
				sp.y = rpArr[j].y - height;
			}
		}
		
		private function moveSlices(elapsed:Number):void
		{
			var destPt:Vector2d = scl.locusPath;
			
			ik.roll(destPt, elapsed);
			
			var _parr:Vector.<Point2d> = ik.locusPoints;
			for (var j:uint = 0; j < _parr.length; j++)
			{
				pArr[j].x = _parr[j].x;
				pArr[j].y = _parr[j].y * yScale;
			}
			
			fp.x = Math.cos(ik.segments[0].rotation) * ik.range + ik.segments[0].x;
			fp.y = (Math.sin(ik.segments[0].rotation) * ik.range + ik.segments[0].y) * yScale;
			fp.y >= 0 && [fp.y = 0];
			//modiy position 
			for (j = 0; j < slices.length; j++)
			{
				slices[slices.length - 1 - j].x = pArr[j].x;
				slices[slices.length - 1 - j].y = pArr[j].y - height;
			}
			
			//modify pieces's geometrics			
			var sp:SlicePiece, rightCx:Number, rightCy:Number, matx:Matrix, disX:Number, disX2:Number;
			for (j = 1; j < slices.length; j++)
			{
				sp = slices[j - 1];
				rightCx = rpArr[j].x;
				rightCy = rpArr[j].y;
				disX = slices[j].x - rpArr[j + 1].x;
				disX2 = sp.x - rightCx;
				sp.show(disX2 >= 0 ? 2 : 1);
				disX2 >= 0 ? rightCx = Math.floor(rightCx) : rightCx = Math.ceil(rightCx);
				
				matx = sp.transform.matrix;
				matx.a = -(sp.x - rightCx) / spWid;
				matx.b = Math.tan(Math.atan2(sp.y - rightCy, sp.x - rightCx)) * matx.a;
				sp.transform.matrix = matx;
			}
			
			//modify last piece			
			sp = slices[slices.length - 1];
			rightCx = fp.x;
			rightCy = fp.y;
			disX = sp.x - rightCx;
			if (disX <= 0)
			{
				rightCx = Math.floor(rightCx);
				sp.show(1);
			}
			else
			{
				rightCx = Math.ceil(rightCx);
				sp.show(2);
			}
			matx = sp.transform.matrix;
			matx.a = -(sp.x - rightCx) / spWid;
			matx.b = Math.tan(Math.atan2(sp.y - fp.y + height, sp.x - rightCx)) * matx.a;
			sp.transform.matrix = matx;
		}
		
		
		//------ getter()/setter() methods ------------
		
		public function get fp():Point2d
		{
			return _followPoint;
		}
		
		public function set fp(point:Point2d):void
		{
			_followPoint = point;
		}
		
		//暫存影像資料
		public function get bufferData():BitmapData
		{
			return _bufferData;
		}
		
		public function set bufferData(source:BitmapData):void
		{
			_bufferData = source.clone();
		}
		
		public function get bitmapData():BitmapData
		{
			return _canvasData;
		}
		
		public function set bitmapData(source:BitmapData):void
		{
			_canvasData = source.clone();
		}
		
		public function get bitmap():Bitmap
		{
			return _canvas;
		}
		
		public function set bitmap(source:Bitmap):void
		{
			_canvas = new Bitmap(source.bitmapData.clone());
		}
		
		public function get drawingBuffer():Shape
		{
			return _drawingShape;
		}
		
		public function set drawingBuffer(buffer:Shape):void
		{
			_drawingShape = buffer;
		}
		
		public function set(buffer:Shape):void
		{
			_drawingShape = buffer;
		}
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
		}
		
		public function get slices():Vector.<SlicePiece>
		{
			return _sliceImages;
		}
		
		public function set slices(collects:Vector.<SlicePiece>):void
		{
			_sliceImages = collects;
		}
		
		public function get sliceNum():uint
		{
			return _sliceNum;
		}
		
		public function set sliceNum(value:uint):void
		{
			_sliceNum = value;
			ik = new IK(spWid, value);
		}
		
		public function get locus():Vector.<Point>
		{
			return _locus;
		}
		
		public function set locus(collects:Vector.<Point>):void
		{
			_locus = collects;
		}
		
		public function get tracker():BaseParticle
		{
			return _tracker;
		}
		
		public function set tracker(point:BaseParticle):void
		{
			_tracker = point;
		}
		
		public function get ik():IK
		{
			return _ik;
		}
		
		public function set ik(target:IK):void
		{
			_ik = target;
		}
		
		public function get scl():SemicircleLocus
		{
			return _scl;
		}
		
		public function set scl(target:SemicircleLocus):void
		{
			_scl = target;
		}
		
		public function get handleX():Number
		{
			return scl.handleX;
		}
		
		public function set handleX(value:Number):void
		{
			scl.handleX = value;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(tint:uint):void
		{
			_color = tint;
		}
		
		public function get spWid():Number
		{
			return int(width / _sliceNum);
		}
		
		public function get isLeft():Boolean
		{
			var rect:Rectangle = this.sliceContainer.getBounds(sliceContainer);
			return rect.x < 0;
		}
		
		public function get rect():Rectangle
		{
			var rect:Rectangle = this.sliceContainer.getBounds(sliceContainer);
			rect.x += x;
			rect.y += y + height;
			return rect;
		}
		
		//-------------------------------------------
		public function addLeftShadow():void
		{
			_shadowL = new PageShadow('left', width >> 1, height);
		}
		
		public function addRightShadow():void
		{
			_shadowR = new PageShadow('right', width >> 1, height);
		}
		
		public function setColor(tint:uint, amount:Number = 1.0):void
		{
			amount = Math.min(1.0, amount);
			var cTrans:ColorTransform = ColorUtils.colorTransform(tint, amount);
			color = cTrans.color;
			if (_shadowL)
			{
				_shadowL.setColor(tint);
			}
			if (_shadowR)
			{
				_shadowR.setColor(tint);
			}
		}
		
		public function setSize(w:Number, h:Number):void
		{
			width = w;
			height = h;
			
			var sWide:Number = Math.min(maxShadowWidth, width >> 1);
			
			if (_shadowL)
			{
				_shadowL.setSize(sWide, height);
			}
			if (_shadowR)
			{
				_shadowR.setSize(sWide, height);
			}
		}
		
		/**
		 *  建立頁面的局部截圖組合
		 * @param	oriFront , 正面影像
		 * @param	oriBack , 反面影像
		 * 將正反兩面的影像依照固定比例切割、分別存入SlicePiece物件所成的陣列集合；最終利用這些集合的物件的幾何變形效果，製告出影像翻頁的動畫效果。
		 */
		private function createSlices(sourceFront:DisplayObject, sourceBack:DisplayObject, pieces:int):void
		{
			if (ik == null)
			{
				sliceNum = pieces;
			}
			else
			{
				ik.ns = pieces;
			}
			
			if (slices !== null)
			{
				clearSlices();
			}
			
			slices = new Vector.<SlicePiece>();
			
			for (var j:uint = 0; j < sliceNum; ++j)
			{
				var sp:SlicePiece = new SlicePiece(sourceFront, sourceBack, spWid * j, 0, spWid, height);
				sp.y = -height;
				//sp.y = 0;
				sp.x = spWid * j;
				sp.oriMatrix = sp.transform.matrix;
				slices.push(sp);
				sliceContainer.addChild(sp);
			}
			
			pArr = new Vector.<Point2d>();
			for (j = 0; j < slices.length; j++)
			{
				pArr.push(new Point2d());
			}
			
			rpArr = VectorUtils.vector2Array(slices).concat();
			rpArr.push(new Point2d()); //多增加一個控制點
		
		}
		
		private function clearSlices():void
		{
			slices.forEach(function(item:SlicePiece, index:int, vector:Vector.<SlicePiece>):void
				{
					item.dispose();
					item = null;
				});
		}
		
		//-------------- 繪製影像 ---------------------
		
		override protected function draw(context:DisplayObject):void
		{
			
			//draw in memory
			bufferData.fillRect(bufferData.rect, color);
			drawContent();
			//	drawShadow();
			//drawDebug(_sclContainer, true);
			drawMapping(context);
		
		}
		
		private function drawContent():void
		{
			var mat:Matrix = sliceContainer.transform.matrix;
			mat.tx = x + sliceContainer.x;
			mat.ty = y + sliceContainer.y + height;
			bufferData.draw(sliceContainer, mat);
		}
		
		private function drawShadow():void
		{
			var mat:Matrix = new Matrix();
			var destX:Number = x + (width >> 1);
			mat.translate(destX, 0);
			if (_shadowL)
			{
				_shadowL.rendering(drawingBuffer);
				bufferData.draw(drawingBuffer, mat);
			}
			
			if (_shadowR)
			{
				_shadowR.rendering(drawingBuffer);
				bufferData.draw(drawingBuffer, mat);
			}
		}
		
		private function drawDebug(context:DisplayObject, valid:Boolean = false):void
		{
			if (!valid)
				return;
			
			var mat:Matrix = new Matrix();
			var dx:Number = x + scl.x;
			var dy:Number = y + width + scl.y;
			mat.translate(dx, dy);
			
			scl.rendering(context);
			bufferData.draw(context, mat);
		}
		
		private function drawMapping(context:DisplayObject):void
		{
			var gs:Graphics = drawingBuffer.graphics;
			
			//draw background;
			bitmapData = bufferData.clone();
			bitmap.bitmapData = bitmapData;
			//bufferData.dispose();
			
			//show memory on screen
			if (context is DisplayObjectContainer)
			{
				if (!DisplayObjectContainer(context).contains(sliceContainer))
				{
				//sliceContainer.x = x;
				//sliceContainer.y = y + height;
					//DisplayObjectContainer(context).addChild(sliceContainer);
				}
				
				if (!DisplayObjectContainer(context).contains(bitmap))
				{
					trace('add degub scl ');
					DisplayObjectContainer(context).addChild(bitmap);
				}
					//	trace('Add Flipper Image',bitmap.width,bitmap.height,DisplayObjectContainer(context).numChildren);
			}
			else
			{
				if (context.hasOwnProperty('graphics'))
				{
					gs = (context is Sprite) ? Sprite(context).graphics : (context is MovieClip) ? MovieClip(context).graphics : null;
					with (gs)
					{
						beginBitmapFill(bufferData, null, false, smoothing);
						drawRect(0, 0, width, height);
						endFill();
					}
				}
			}
		}
	}

}
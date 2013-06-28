package com.intuitStudio.biMotion.core
{
	
	/**
	 * PhysicalEntry Class
	 * @author vanier peng , 2013.4.18
	 * 一個模擬現實世界的物理特性的實體類別，繼承自BaseParticle類別
	 * 以數學公式計算運動、碰撞等運動及交互作用
	 * 可做為其他模擬現實世界的物體的基礎父類別 ;
	 * 與父類別的最大不同點在於距離的計算採單位距離，並且考慮時間的重要因素在內
	 */
	import com.intuitStudio.utils.MathTools;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.utils.Dictionary;
	import flash.display.Graphics;
	
	public class PhysicalEntry extends BaseParticle
	{
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;

		
		public function PhysicalEntry(x:Number=0,y:Number=0)
		{
		   super(x, y);
		   width = height = 1;
		   radius = 0;
		}
		
		public function get scaleX():Number
		{
			return _scaleX; 
		}
		
		public function set scaleX(value:Number):void
		{
			_scaleX = value;
		}
		
		public function get scaleY():Number
		{
			return _scaleY; 
		}
		
		public function set scaleY(value:Number):void
		{
			_scaleX = value;
		}
		
		
		
    	/**
    	* 計算物體的幾何範圍，
    	* 預設物體的參考座標點位在物體的中心點，所以左上角各調整長寬值的一半
	    *
	    */
		override public function getBounds():Rectangle {
			var bound:Rectangle;
			if (radius > 0 {
				bound = super.getBounds();
			}else {
				bound = new Rectangle(x-(width>>1),y-(height>>1),width,height);
			}
			return bound;
		}
		
	    /**
	    * 取得半徑大小，若為非球體則取長寬較大者
	    */
	    public function getRadius():Number {
		    return (this.radius>0)?this.radius:Math.max(width,height);
	    }
		
		public function reachBounds(dir:String):Boolean
		{
			var reach:Boolean = false;
			if (_margin) {
				
				var left:Number = margin.left;
				var right:Number = margin.right;
				var top:Number = margin.top;
				var bottom:Number = margin.bottom;
				
				if (tx > right || tx < left || ty > bottom || ty < top) {
					tx = MathTools.clamp(tx, left, right);
					ty = MathTools.clamp(ty, top, bottom);
     			}
				
				if (dir === 'left') { reach = (tx === left); }
				if (dir === 'right') { reach = (tx === right); }
				if (dir === 'top') { reach = (ty === top); }
				if (dir === 'bottom') { reach = (ty === bottom); }
         
			}
			return reach;		
		}
		
		override public function setMargin(boundW, boundH):void
		{
			margin = new Rectangle(width>>1, height>>1, boundW - (width>>1), boundH - (height>>1));
		}
		
		override protected function draw(context:DisplayObject):void
		{
			if (context.hasOwnProperty('graphics'))
			{
               var gs:Graphics = (context is Sprite)?Sprite(context).graphics:
				                 (context is Shape)?Shape(context).graphics:null;
				 
				with (gs)
				{
					//clear();
					lineStyle(0);
					beginFill(0xFF0000);
					drawRect(x-(width>>1),y-(height>>1),width,height));
					endFill();
				}
			}
		} 
		
		//--- public static methods --------
		
	   /**
	   * 將指定的座標向量相對於另一座點為中心點，並且旋轉座標軸angle角度，求得相對座標位置並且回傳
	   * @param {Point,angle,Point} , 目標座標向量 , 座標軸旋轉徑度 ,新的中心點座標向量
	   * @return {Vector2d} 新的相對座標位置向量
	   */
		public static function coordinateRotateTo(point:Point,angle:Number,center:Point):Point {
			point = point.subtract(center);
			var diff:Vector2d = new Vector2d(point.x, point.y);
			diff = PhysicalEntry.doCoordinateRotate(dest, angle);
			return new Point(diff.x,diff.y);
    	}
		
		public static function doCoordinateRotate(v:Vector2d, angle:Number):Vector2d
		{
		   var cos:Number = Math.cos(angle);
		   var sin:Number = Math.sin(angle);
		   return  new Vector2d(v.x*cos - v.y*sin,v.y*cos+v.x*sin);
		}
		
		public static function getRelativeMotions(diff:Vector2d, v0:Vector2d, v1:Vector2d):Dictionary
		{
			var dic:Dictionary = new Dictionary();
		    var angle:Number = diff.angle;			
		    dic['p0r'] = new Vector2d();		
		    dic['p1r'] = PhysicalEntry.doCoordinateRotate(diff, -angle);
		    dic['v0r'] = PhysicalEntry.doCoordinateRotate(v0, -angle);
		    dic['v1r'] = PhysicalEntry.doCoordinateRotate(v1,-angle);	
		    return dic;
		}
		
		public static function restoreRelativeMotions(angle:Number, p0r:Vector2d, p1r:Vector2d, v0r:Vector2d, v1r:Vector2d, distance:Number):Dictionary
		{
			if (distance) {
		      //分開距離前先檢查是否靠得太近，容易發生卡住的問題
              //以絕對值計算碰撞後的速度分值，再分配給重疊的距離，以確保兩者之間至少維持最短距離
		      var absV:Number = Math.abs(v0r.x) + Math.abs(v1r.x);
		      var overlap:Number = distance - Math.abs(p0r.x-p1r.x);
		      p0r.x += (v0r.x/absV)*overlap;
		      p1r.x += (v1r.x/absV)*overlap;	
			}
		    //rotate back
			var dic:Dictionary = new Dictionary();
			dic['p0'] = PhysicalEntry.doCoordinateRotate(p0r, angle);
			dic['p1'] = PhysicalEntry.doCoordinateRotate(p1r,angle);
			dic['v0'] = PhysicalEntry.doCoordinateRotate(v0r,angle);
			dic['v1'] = PhysicalEntry.doCoordinateRotate(v1r,angle);
	        return dic;
	   	}
		
	    /**
	    * 類別靜態函式，動量守恆公式計算物體碰撞後的速度結果
	    * @param {m0,m1,p0,p1,v0,v1,minDist[,elapsed]} Numvwe,Number,Vector2d,Vector2d,Vector2d,Vector2d,Number 兩物體質量、碰撞前的位置與速度，調整用的最短距離,以及時間
	    * @return {p0:Vector2d,p1:Vector2d,v0:Vector2d,v1:Vector2d} 碰撞後結果物件,依照傳入的參數順序回傳最後的位置和速度
	   */
		public static function freeCollide(m0:Number,m1:Number,p0:Vector2d,p1:Vector2d,v0:Vector2d,v1:Vector2d,distance:Number,elapsed:Number=1.0):Dictionary
		{
			var diff:Vector2d = p1.subtract(p0);
			var dic:Dictionary = PhysicalEntry.getRelativeMotions(diff,v0,v1);
		    //以X軸向的碰撞檢測方法計算碰撞後的速度變化結果
		    var afterCollide:Vector.<Vector2d> = PhysicalEntry.xCollide(m0,m1,dic.v0r,dic.v1r);
		    dic.v0r = afterCollide[0];
		    dic.v1r = afterCollide[1];
			return PhysicalEntry.restoreRelativeMotions(diff.angle,dic.p0r,dic.p1r,dic.v0r,dic.v1r,distance);
		}
		
		public static function freeCollideDetect(m0:Number,m1:Number,p0:Vector2d,p1:Vector2d,v0:Vector2d,v1:Vector2d,distance:Number,elapsed:Number=1.0):Dictionary
		{
			var diff:Vector2d = p1.subtract(p0);
			var dic:Dictionary = PhysicalEntry.getRelativeMotions(diff, v0, v1);
			var hitTime:Number = PhysicalEntry.calculateCollideTime(diff.angle,dic.p0r,dic.p1r,dic.v0r,dic.v1r,distance,elapsed);	
			if (hitTime !== null) {
		       //以X軸向的碰撞檢測方法計算碰撞後的速度變化結果
		       var afterCollide:Vector.<Vector2d> = PhysicalEntry.xCollide(m0,m1,dic.v0r,dic.v1r);
		       dic.v0r = afterCollide[0];
		       dic.v1r = afterCollide[1];
			   return PhysicalEntry.restoreRelativeMotions(diff.angle,dic.p0r,dic.p1r,dic.v0r,dic.v1r,distance);
			}
			return null;			
		}		
		
		public static function xCollide(m0:Number,m1:Number,v0:Vector2d,v1:Vector2d):Vector.<Vector2d>
		{
		   var vxTotal:Number = v0.x-v1.x;
		   //collision reaction of tow same mass objects ,swap the two veocities
		   if(m0===m1){
			   var tempX:Number = v0.x;
			   v0.x = v1.x;
			   v1.x = tempX;			
		  }else{			
			   v0.x = ((m0-m1)*v0.x+2*m1*v1.x)/(m0+m1);
		   	   v1.x = vxTotal + v0.x;			 
		   };	
		   var result:Vector.<Vector2d> = Vector.<Vector2d>([v0, v1]);
		   return result;
		}

	/**
	* 偵測兩物體發生碰撞的時間。利用座標旋轉公式將一般碰撞簡化成X軸向的碰撞模式，計算需要花費的時間
	* 計算公式的原理 : (y軸部份簡化為0, 故可以省略不計)
	* 兩物體之間的距離 = 影格時間內移動距離的和 = 勾股定理的距離公式
	* dis = Math.sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0)) = Math.sqrt(-2*x0*x1+x0*x0+x1*x1);
	* 以 x0 = p0x+v0x*t , x1 = p1x+v1x*t 代入以上等式,展開的公式形式 : 
	* dis*dis = t平方*(-2*v0x*v1x)+ t*(-2*p0x*v1x-2*p1x*v0x)+(-2*p0x*p1x+p0x*p0x+p1x8p1x)
	* t平方*(-2*v0x*v1x+v0x*v0x+v1x*v1x)+t*(-2*p0x*v1x-2*p1x*v0x+2*p0x*v0x+2*p1x*v1x)+(-2*p0x*p1x+p0x*p0x+p1x*p1x)-dis*dis = 0
	* a*t平方+b*t+c-R平方 = 0 ,解t的二次方程求解
	* t1 = (-b+Math.sqrt(b*b-4*a*(c-R平方)))/2*a
	* t2 = (-b-Math.sqrt(b*b-4*a*(c-R平方)))/2*a
	* 當t1或t2 介於0到1之間時，表示碰撞發生於影格間
	*/
		public static function collisionDetectMath2(p0:Vector2d, p1:Vector2d, v0:Vector2d, v1:Vector2d, distance:Number, elapsed:Number = 1.0):Boolean
		{
		   var diff:Vector2d = p1.subtract(p0);
		   var dic:Dictionary = PhysicalEntry.getRelativeMotions(diff,dic.v0,dic.v1);
		   var hitTime = PhysicalEntry.calculateCollideTime(diff.angle,dic.p0r,dic.p1r,dic.v0r,dic.v1r,distance,elapsed);
		   return (hitTime!=Infinity);			
		}
		
		public static function calculateCollideTime(angle:Number,p0r:Vector2d,p1r:Vector2d,v0r:Vector2d,v1r:Vector2d,distance:Number,elapsed:Number=1.0):Number
		{
		   var R:Number = distance / Math.sin(angle);
		   var a:Number = -2 * v0r.x * v1r.x + v0r.x * v0r.x + v1r.x * v1r.x;
		   var b:Number = -2 * p0r.x * v1r.x - 2 * p1r.x * v0r.x + 2 * p0r.x * v0r.x + 2 * p1r.x * v1r.x;
		   var c:Number = -2 * p0r.x * p1r.x + p0r.x * p0r.x + p1r.x * p1r.x;
		   var sqRoot:Number = Math.sqrt(b * b - 4 * a * (c - R * R));
		   var t1:Number = ( -b + sqRoot) / (2 * a);
		   var t2:Number = ( -b - sqRoot) / (2 * a);		
		   var hitTime:Number = Infinity;
		   var bang:Boolean = false;		
		   if(t1>0 && t1<=1){
			   hitTime = t1;
		   }		
		   if(t2>0 && t2<=1){
			  if(hitTime==Infinity) {hitTime = t2;}
		   }		
		   return hitTime;
		}
		
		public static function gravitateBetween(partA:BaseParticle,partB:BaseParticle,elapsed:Number=1.0):void
		{
			var diff:Vector2d = partB.bufferPoint.subtract(partA.bufferPoint);
			var thrust:Number = partA.mass * partB.mass / diff.length;
			var acc:Vector2d = (diff.multiply(force)).divide(diff.length);
			partA.acceleration = (acc.divide(partA.mass)).multiply(elapsed);
			partB.acceleration = (acc.divide(partB.mass)).multiply(-elapsed);
		}
		
		public static function springBetween(partA:BaseParticle, partB:BaseParticle, distance:Number, springAmount:Number, elapsed:Number = 1.0):Boolean
		{
			var diff:Vector2d = partB.bufferPoint.subtract(partA.bufferPoint);
			if (diff.length < distance) {
				var acc:Vector2d = diff.multiply(springAmount);
			    partA.acceleration = (acc.divide(partA.mass)).multiply(elapsed);
			    partB.acceleration = (acc.divide(partB.mass)).multiply(-elapsed);
                return true;
			}
			return false;
		}
		
	}//end of class

}
package com.intuitStudio.dataProcess 
{
/**
 * Matrices Class
 * @author vanier peng ,2013.4.18
 * 定義數學矩陣的工具，除了可以用做儲存資料外，也可以做為計算座標旋轉、縮放以及平移等輔助工具
 * 提供基本的行列運算 ; 矩陣的資料排列方式以行為基準 , 例如3X3的矩陣資料為每3個元素表示一行,共有3組資料(列)  
 */
	public class Matrices 
	{
		private var _row:uint=0;
		private var _column:uint = 0;
		private var _rawData:Vector.<Number>;
		public function Matrices(row:uint,col:uint,data:Vector.<Number>=null) 
		{
			_row = row;
			_column = col;
			_rawData = data || new Vector.<Number>();
		}
		
		public function get row():uint {
			return _row;
		}
		
		public function set row(value:uint):void
		{
			_row = value;
		}
		
		public function get column():uint {
			return _column;
		}
		
		public function set column(value:uint):void
		{
			_column = value;
		}		
		
		public function get rawData():Vector.<Number>
		{
			return _rawData;
		}
		
		public function set rawData(data:Vector.<Number>):void
		{
			_rawData = data;
		}		
				
		public function clone():Matrices
		{
			var mat:Matrices =  new Matrices(row, column);
            myVector.forEach(myFunction);
            return mat;			
			
            function copyElement(item:Number, index:int, vector:Vector.<Number>):void {
               mat.rawData.push(item);
            };			
		}
		
		public function add(mat:Matrices):void {
			var destMat:Matrices = this.clone();
		    for(var i:int=0;i<row;i++){
			   for(var j:int=0;j<column;j++){
				  var idx:int = j+i*column;
				  oriMat.rawData[idx] += mat.rawData[idx] ;
			   }
		    }
			return destMat;
		}
		
		public function subtract(mat:Matrices):void {
			var destMat:Matrices = this.clone();
		    for(var i:int=0;i<row;i++){
			   for(var j:int=0;j<column;j++){
				  var idx:int = j+i*column;
				  oriMat.rawData[idx] -= mat.rawData[idx] ;
			   }
		    }
			return destMat;
		}		
		
		public function multiply(mat:Matrices):Vector.<Number>
		{
			var result:Vector.<Number> = new Vector.<Number>(row*column);
			var rowData:Vector.<Number> = new Vector.<Number>();
			var colData:Vector.<Number> = new Vector.<Number>();
		    for(var i=0;i<this.row;i++){
			   rowData = this.getRowData(i);			
		       // console.log('current row = ' + rowData);
			   for(var sum = 0,j=0;j<this.col;j++){			
			  	  colData = mat.getColumnData(j);
				  sum = 0;
				  rowData.forEach(function(element,idx){
			        sum += element*colData[idx];					
				  });
				  //console.log('idx = ' + (i+j*this.col));
				  result[i+j*this.row] = sum;
			   };
		    };			
		}
		
		public function getRowData(index:int):Vector.<Number>
		{
			var list:Vector.<Number> = new Vector.<Number>();
 		    for(var i:int=0;i<column;i++){
			  var idx:int = i*row+index;			
			  list.push(rawData[idx]);
		    } 
		    return list;
		}
		
		public function setRowData(index:int,data:Vector.<Number>):void
		{
 		    for(var i:int=0;i<column;i++){
			  var idx:int = i*row+index;			
			  rawData[idx] = data[i];
		    } 	
		}		
		
		public function getColumnData(index:int):Vector.<Number>
		{
			var list:Vector.<Number> = new Vector.<Number>();
 		    for(var i:int=0;i<row;i++){
			  var idx:int = i+index*column;			
			  list.push(rawData[idx]);
		    } 
		    return list;
		}
		
		public function setColumnData(index:int,data:Vector.<Number>):void
		{
 		    for(var i:int=0;i<row;i++){
			  var idx:int = i+index*column;			
			   rawData[idx] = data[i];
		    } 
		}		
		
		public function toString():String {
			return 'Matrices : ' + rawData.toString();
		}
		
		
	}//end of class

}
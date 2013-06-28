package com.intuitStudio.motions.triDimens.isometric
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.Dictionary;
	import flash.geom.Vector3D;

	import com.intuitStudio.motions.triDimens.isometric.core.IsoObject;
	import com.intuitStudio.motions.triDimens.isometric.concretes.IsoWorld;
	import com.intuitStudio.motions.triDimens.isometric.factories.IsoTileFactory;
	import com.intuitStudio.motions.triDimens.isometric.concretes.GraphicTile;
	import com.intuitStudio.projects.IsoWorld.factories.WorldFactory;

	import com.intuitStudio.utils.AssetUtils;
	import flash.errors.IllegalOperationError;


	public class MapLoader extends EventDispatcher
	{
		protected var _grid:Array;
		protected var _loader:URLLoader;
		protected var _tileDefs:Dictionary;
		protected var _floorDef:Dictionary;
		protected var _tileFc:IsoTileFactory;
		protected var _world:IsoWorld;

		public function MapLoader ()
		{
			init ();
		}

		private function init ():void
		{
			_tileDefs = new Dictionary();
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
		}

		public function loadMap (url:String):void
		{
			_loader.addEventListener (Event.COMPLETE,onMapLoad);
			_loader.load (new URLRequest(url));
		}

		private function onMapLoad (e:Event):void
		{
			var mapData:String = _loader.data as String;
			parseMap (mapData);
			dispatchEvent (new Event(Event.COMPLETE));
		}

		protected function parseMap (data:String):void
		{
			var lines:Array = data.split('\r\n');
			_grid = new Array();
			for (var i:uint=0; i<lines.length; i++)
			{
				var line:String = lines[i];
				if (isDefinition(line))
				{
					parserDefinition (line);
				}
				else if (!isNoDefinition(line) && !isComment(line))
				{
					var cells:Array = line.split(' ');
					_grid.push (cells);
				}
			}
		}	
		
/*
		   definition :
            # 0 type:GraphicTile graphicClass:MapTest_Tile01 xoffset:20 yoffset:10 walkable:true
            # 1 type:GraphicTile graphicClass:MapTest_Tile02 xoffset:20 yoffset:30 walkable:false
            # 2 type:DrawnIsoBox color:0xff6666 walkable:false height:20
            # 3 type:DrawnIsoTile color:0x6666ff walkable:false
		*/
		private function parserDefinition (value:String):void
		{
			var tokens:Array = value.split(" ");
			tokens.shift ();
			//remove #;
			var symbol:String = tokens.shift();

			var definition:Dictionary = new Dictionary();
			for (var i:uint=0; i<tokens.length; i++)
			{
				var keyValues:Array = tokens[i].split(':');
				definition[keyValues[0]] = keyValues[1];
			}
			setTileType (symbol,definition);
			_floorDef = _tileDefs['0'];
		}

		private function setTileType (symbol:String,value:Dictionary):void
		{
			_tileDefs[symbol] = value;
		}

		private function isDefinition (value:String):Boolean
		{
			return value.indexOf('#')==0;
		}

		private function isNoDefinition (value:String):Boolean
		{
			for (var i:uint=0; i<value.length; i++)
			{
				if (value.charAt(i) != ' ')
				{
					return false;
				}
			}
			return true;
		}

		// this is a comment.
		private function isComment (value:String):Boolean
		{
			return value.indexOf('//')==0;
		}
		//
		public function makeWorld (type:int):IsoWorld
		{
			var gridSize:Vector3D = new Vector3D(_grid.length,_grid[0].length,_floorDef.size);
			_world = WorldFactory.makeWorld(type,gridSize);
			makeFloor (type);
			makeStuff ();
			return _world;
		}

		private function makeFloor (type:int):void
		{
			if (type == IsoWorld.WORLD_NORMAL)
			{
				_world.makeFloor ();
			}
			if (type == IsoWorld.WORLD_GRAPHIC)
			{
				_world.makeFloor (_floorDef);
			}
		}

		protected function makeStuff ():void
		{
           throw new IllegalOperationError('makeStuff must be overridden by sub calss');
		}

	}

}
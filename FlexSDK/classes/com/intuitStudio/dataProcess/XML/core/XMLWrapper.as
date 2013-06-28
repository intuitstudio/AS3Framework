package com.intuitStudio.dataProcess.XML.core
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.errors.IllegalOperationError;
	import com.intuitStudio.loaders.concretes.XmlLoader;

	public class XMLWrapper extends EventDispatcher
	{
		protected var _loader:XmlLoader;
		protected var _data:XML;
		protected var _valid:Boolean = false;
		protected var _ignoreWhiteSpace:Boolean;
		protected var _ignoreComments:Boolean;

		public function XMLWrapper (pathOrClass:Object=null,ignoreSpace:Boolean=true,ignoreComments:Boolean=true)
		{
			_ignoreWhiteSpace = ignoreSpace;
			_ignoreComments = ignoreComments;
			init (pathOrClass);
		}

		protected function init (pathOrClass:Object = null):void
		{
			addEventListener (Event.COMPLETE,onXMLReady);
			XML.ignoreWhitespace = _ignoreWhiteSpace;
			XML.ignoreComments = _ignoreComments;
			if(pathOrClass)
			{
			   makeXML (pathOrClass);
			}
		}

		protected function makeXML (pathOrClass:Object):void
		{
			var classRef:Class = pathOrClass as Class;
			if (classRef != null)
			{
				makeXMLByClass (classRef);
			}
			else
			{
				var source:XML = makeXMLByFactory(pathOrClass as String);
				if (source != null)
				{
					_data = source;
					dispatchEvent (new Event(Event.COMPLETE));
				}
				else if ( (pathOrClass as String ) != null)
				{
					makeXMLByLoadFile (pathOrClass as String);
				}
				else
				{
					throw new IllegalOperationError('Invalid object passed to XmlWrapper !');
				}
			}
		}

		private function makeXMLByClass (classRef:Class):void
		{
			_data = XML(new classRef());
			dispatchEvent (new Event(Event.COMPLETE));
		}

		protected function makeXMLByFactory (assetName:String):XML
		{
			//throw new IllegalOperationError('makeXMLByFactory must be overridden by derivative classes !');
			return null;
		}

		protected function makeXMLByLoadFile (url:String):void
		{
			if (_loader == null)
			{
				valid = false;
				_loader = new XmlLoader();
				_loader.addEventListener (Event.COMPLETE,onXmlLoaded);
			}
			_loader.load (url);
		}

		public function makeXMLByData (data:XML):void
		{
			_data = data;
			dispatchEvent (new Event(Event.COMPLETE));
		}

		protected function onXMLReady (e:Event):void
		{
			removeEventListener (Event.COMPLETE,onXMLReady);
			valid = true;
			dispatchEvent (new Event(Event.CHANGE));
		}

		private function onXmlLoaded (e:Event):void
		{
			_data = _loader.data;
			_loader.removeEventListener (Event.COMPLETE,onXmlLoaded);
			_loader = null;
			dispatchEvent (e);
		}

		public function get data ():XML
		{
			return _data;
		}

		public function set valid (value:Boolean):void
		{
			_valid = value;
		}

		public function get valid ():Boolean
		{
			return _valid;
		}

	}

}
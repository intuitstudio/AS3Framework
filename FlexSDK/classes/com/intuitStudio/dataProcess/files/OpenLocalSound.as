package com.intuitStudio.dataProcess.files
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.net.FileFilter;
	import flash.net.FileReferenceList;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.events.ErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
    import flash.net.URLLoader;    
    import flash.net.URLLoaderDataFormat;    
    import flash.net.URLRequest;
	
	import com.adobe.audio.format.WAVWriter;
	import com.fr.kikko.lab.ShineMP3Encoder;

	import com.intuitStudio.loaders.core.OpenLocalFile;
	import com.intuitStudio.loaders.concretes.AudioLoader;
	import com.intuitStudio.audios.core.AudioController;


	public class OpenLocalSound extends OpenLocalFile
	{
		public static const MAXSAMPLES:int = 8192;
		public static const MP3:int = 1;
		public static const WAV:int = 0;
		public static const TIME_IS_UP:String = 'timeisUp';

		protected var _soundController:AudioController;
		protected var _byteArray:ByteArray;
		protected var _loader:AudioLoader;
		public var recorder:*;
		private var _audioData:ByteArray;

		public var wavWriter :WAVWriter = new WAVWriter();
		public var mp3Encoder:ShineMP3Encoder;

		public function OpenLocalSound ()
		{
			super ();
		}

		override protected function doMakeFileFilter ():void
		{
			_fileFilters = [new FileFilter("Sounds","*.mp3;*.wav")];
		}

		override protected function onFileSelect (e:Event):void
		{
			_file.addEventListener (Event.COMPLETE,onSoundLoadComplete);
			_file.addEventListener (Event.CANCEL,onSoundLoadCancel);
			_file.load ();
		}

		private function onSoundLoadComplete (e:Event):void
		{
			_file.removeEventListener (Event.COMPLETE,onSoundLoadComplete);
			_file.removeEventListener (Event.CANCEL,onSoundLoadCancel);


			_loader = new AudioLoader()  ;
			_loader.addEventListener (Event.COMPLETE,onLocalFileRead);
			
			_byteArray = new  ByteArray();
			ByteArray(_file.data).position = 0;

			//_byteArray.writeBytes (_file.data);
			//_byteArray.position = 0;

			//trace ('bytesAviable',_byteArray.bytesAvailable,_byteArray.length);

			//var dynamicSound:Sound = new Sound();
			//dynamicSound.addEventListener (SampleDataEvent.SAMPLE_DATA, onSampleData);

			//dynamicSound.play ();

			var loader: URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
          

			//_byteArray = new  ByteArray();
			// ByteArray(_file.data).position = 0;
			//_byteArray.writeObject (_file.data);
			// _byteArray.writeBytes(_file.data);


			//transMP3();
/*
			 	 var sp:Sprite = new Sprite();
			 sp.addEventListener(Event.ENTER_FRAME,onFrameLoop);
						 
			function onFrameLoop(e:Event):void
			{
				if(bytes.length==ByteArray(_file.data).length)
				{
				   trace('zz ',bytes.bytesAvailable,bytes.length)
				   _byteArray = bytes;
				   e.target.removeEventListener(Event.ENTER_FRAME,onFrameLoop);
				   _loader.dispatchEvent(new Event(Event.COMPLETE));
				  //_loader.loader.loadBytes (bytes);
				}
			}
			*/

			//_file.save (_byteArray, "done2.mp3");
		}

		private function onSampleData (e:SampleDataEvent):void
		{
			for (var i:int; i < 8192 && _byteArray.bytesAvailable > 0; i++)
			{
				var left:Number = _byteArray.readFloat();
				var right:Number = _byteArray.readFloat();
				e.data.writeFloat (left);
				e.data.writeFloat (right);
			}
		}


		public function transMP3 ():void
		{
			_byteArray.position = 0;
			var resultSamples:ByteArray = new ByteArray();
			wavWriter = new WAVWriter();

			wavWriter.processSamples (resultSamples,_byteArray, wavWriter.samplingRate, 1);
			resultSamples.position = 0;
			if (mp3Encoder == null)
			{
				mp3Encoder = new ShineMP3Encoder();
				mp3Encoder.recorder = this.recorder;
			}
			mp3Encoder.wavData = resultSamples;
			mp3Encoder.addEventListener (Event.COMPLETE , onEncodeMP3Complete);
			mp3Encoder.addEventListener (ProgressEvent.PROGRESS,onEncodingProgress);
			mp3Encoder.addEventListener (ErrorEvent.ERROR,onEncodingError);
			mp3Encoder.start ();

		}

		private function onEncodingProgress (e:ProgressEvent):void
		{

		}

		private function onEncodingError (e:ErrorEvent):void
		{
			trace ('endord error');
		}


		private function onEncodeMP3Complete (e:Event)
		{
			mp3Encoder.removeEventListener (Event.COMPLETE , onEncodeMP3Complete);
			mp3Encoder.removeEventListener (ProgressEvent.PROGRESS,onEncodingProgress);
			mp3Encoder.removeEventListener (ErrorEvent.ERROR,onEncodingError);

			trace ("encodeCompoete");

			//var resultSamples:ByteArray = mp3Encoder.mp3Data;
			//resultSamples.position = 0;
			//recorder.saveRecordFile(resultSamples);
			_audioData = mp3Encoder.mp3Data;
			trace (_audioData.length);
			trace (_audioData.bytesAvailable);

		}





		private function onSoundLoadCancel (e:Event):void
		{
			dispatchEvent (e);
		}

		private function onLocalFileRead (e:Event):void
		{
			trace ('local file loaded');
			//var sound:Sound = _file.data as Sound;
			//sound.play();
			//_byteArray = _loader.content() as ByteArray;

			var dynamicSound:Sound = new Sound();
			//dynamicSound.addEventListener (SampleDataEvent.SAMPLE_DATA, onSampleData);

			dynamicSound.play ();
		}


		public function get sound ():AudioController
		{
			return _soundController;
		}

		public function dispose ():void
		{
			if (_file)
			{
				_file.removeEventListener (Event.CANCEL,onSoundLoadCancel);
				_file = null;
			}


			if (_soundController)
			{
				_soundController.dispose ();
				_soundController = null;
			}

		}
	}

}
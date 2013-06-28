package com.intuitStudio.audios.core
{
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;

	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.media.SoundTransform;


	public class AudioController extends EventDispatcher
	{
		protected var _sound:Sound;
		protected var _soundChannel:SoundChannel;
		protected var _loops:int = 0;
		protected var _playing:Boolean = false;
		protected var _timerSprite:Sprite;
		protected var _isMute:Boolean = false;
		protected var _volume:Number=1;

		public function AudioController (pathOrClass:Object=null,volume:Number=.8,loops:int=0)
		{

			_loops = loops;
			_volume = volume;
			if (pathOrClass != null)
			{
				init (pathOrClass);
			}
		}

		protected function init (pathOrClass:Object = null):void
		{
			_sound = new Sound();
			_isMute = false;
			_timerSprite = new Sprite();
			_timerSprite.addEventListener (Event.ENTER_FRAME,onFrameLoop);
			makeSound (pathOrClass);
		}

		public function makeSound (pathOrClass:Object):void
		{
			doMakeSound (pathOrClass);
		}

		public function getSoundSpectrum (fftMode:Boolean = true,stretchFactor:int = 0):ByteArray
		{
			var spectrum:ByteArray  = new ByteArray();
			SoundMixer.computeSpectrum (spectrum,fftMode,stretchFactor);
			return spectrum;
		}

		protected function doMakeSound (pathOrClass:Object):void
		{
			var classRef:Class = pathOrClass as Class;
			if (classRef != null)
			{
				makeSoundByClass (classRef);
			}
			else
			{
				var source:Sound = makeSoundByFactory(pathOrClass as String);
				if (source != null)
				{
					sound = source;
					play ();
				}
				else if ( (pathOrClass as String ) != null)
				{
					makeSoundByLoadFile (pathOrClass as String);
				}
				else
				{
					throw new IllegalOperationError('Invalid object passed to ImageWrapper !');
				}
			}
		}

		private function makeSoundByClass (classRef:Class):void
		{
			sound = new classRef() as Sound;
			play ();
		}

		protected function makeSoundByFactory (assetName:String):Sound
		{
			throw new IllegalOperationError('makeSoundByFactory must be overridden by derivative classes !');
			return null;
		}

		protected function makeSoundByLoadFile (url:String):void
		{
			_sound = new Sound();
			_playing = false;
			try
			{
				_sound.load (new URLRequest(url));
				play ();
			}
			catch (e:Error)
			{
				trace (e.getStackTrace());
			}
		}

		protected function onFrameLoop (e:Event):void
		{
			if (_playing)
			{
				dispatchEvent (new Event(Event.CHANGE));
			}
		}

		protected function onSoundLoaded (e:Event):void
		{
			_sound.removeEventListener (Event.COMPLETE,onSoundLoaded);
			_sound.removeEventListener (IOErrorEvent.IO_ERROR,onLoadError);
			play ();
		}

		protected function onSoundComplete (e:Event):void
		{
			_playing = false;
		}

		private function onLoadError (e:IOErrorEvent):void
		{
			dispatchEvent (e);
		}

		public function set sound (obj:Sound):void
		{
			if (_sound)
			{
				dispose ();
			}

			_sound = obj;
			if (! _sound.hasEventListener(Event.COMPLETE))
			{
				_sound.addEventListener (Event.COMPLETE,onSoundLoaded);
				_sound.addEventListener (IOErrorEvent.IO_ERROR,onLoadError);
			}
		}

		public function dispose ():void
		{
			if (_sound)
			{
				_soundChannel.stop ();
				_sound.close ();
				if (! _sound.hasEventListener(Event.COMPLETE))
				{
					_sound.addEventListener (Event.COMPLETE,onSoundComplete);
					_sound.addEventListener (IOErrorEvent.IO_ERROR,onLoadError);
				}
				_soundChannel.removeEventListener (Event.SOUND_COMPLETE,onSoundComplete);
				_sound = null;
				_soundChannel = null;
			}

		}

		public function get sound ():Sound
		{
			return _sound;
		}

		public function get soundChannel ():SoundChannel
		{
			return _soundChannel;
		}

		public function get isPlaying ():Boolean
		{
			return _playing;
		}

		public function play ():void
		{
			_playing = true;
			_soundChannel = _sound.play(0,_loops);
			_soundChannel.soundTransform.volume = _volume;
			if (! _soundChannel.hasEventListener(Event.SOUND_COMPLETE))
			{
				_soundChannel.addEventListener (Event.SOUND_COMPLETE,onSoundComplete);
			}
		}
		
		public function stop():void
		{
			_soundChannel.stop();
		}
		
		public function mute():void
		{
			_isMute = !_isMute;
			var transform:SoundTransform = new SoundTransform();
			transform.volume = (_isMute)?0.1:_volume;
			soundChannel.soundTransform = transform;
		}
        
		public function get isMute():Boolean
		{
			return _isMute;
		}

	}


}
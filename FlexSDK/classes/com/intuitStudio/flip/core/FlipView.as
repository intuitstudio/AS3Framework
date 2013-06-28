package com.intuitStudio.flip.core
{
	
	/**
	 * FlipView class
	 * @author vanier peng,2013.4.23
	 * 翻頁用的容器
	 */
	
	import flash.display.MovieClip;
	import flash.display.Sprite;	
	import flash.media.Sound;
	import flash.events.Event;
	
	public class FlipView extends Sprite
	{
		//events
		public static const FLIP_L_STARTED = 'fliplstarted';
		public static const FLIP_L_COMPLETED = 'fliplcompleted';
		public static const FLIP_R_STARTED = 'fliprstarted';
		public static const FLIP_R_COMPLETED = 'fliprcompleted';
		public static const SKIP_COMPLETE = "skipcomplete";

		public var startedNum:uint;
		public var completedNum:uint;
	
		public var flipperArr:Vector.<Flipper>;
		private var flipper:Flipper;
		public var isLeft:Boolean;
		//Flip Sounds
		private var sndS:Sound, sndE:Sound;
		
		
		public function FlipView()
		{
		
		}
	
	}

}
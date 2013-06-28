package com.intuitStudio.ui
{
	
	/**
	 * DoubleClickAdjuster Class
	 * @author vanier peng 2013.5.3
	 * 滑鼠雙擊事件
	 * 程式碼來源 : Ticore's Blog - http://ticore.blogspot.com
	 *
	 */
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	[Bindable]
	public var dbClickTime:int = 450;
	
	protected var iObj:InteractiveObject;
	protected var lastClickTime:Number = Number.NEGATIVE_INFINITY;
	protected var lastClickTarget:InteractiveObject = null;
	protected var pauseClickHandler:Boolean = false;
	
	public class DoubleClickAdjuster
	{
		
		public function DoubleClickAdjuster()
		{
		
		}
		
		public function intercept(obj:InteractiveObject):void
		{
			if (iObj)
			{
				iObj.removeEventListener(MouseEvent.CLICK, onMouseClickHandler, true);
				iObj.removeEventListener(MouseEvent.DOUBLE_CLICK, onMouseClickHandler, true);
			}
			iObj = obj;
			if (iObj)
			{
				iObj.addEventListener(MouseEvent.CLICK, onMouseClickHandler, true);
				iObj.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseClickHandler, true);
			}
		}
		
		protected function onMouseClickHandler(e:MouseEvent):void
		{
			if (pauseClickHandler)
			{
				return;
			}
			var clickTime:Number = getTimer();
			var target:InteractiveObject = e.target as InteractiveObject;
			if (!target)
			{
				return;
			}
			if (target.doubleClickEnabled && (target == lastClickTarget) && (clickTime - lastClickTime) <= dbClickTime)
			{
				// Is double-click event.
				if (e.type == MouseEvent.CLICK)
				{
					e.stopImmediatePropagation();
					var dbClickEvt:MouseEvent = new MouseEvent(MouseEvent.DOUBLE_CLICK, true, true, e.localX, e.localY, target, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta);
					pauseClickHandler = true;
					target.dispatchEvent(dbClickEvt);
					pauseClickHandler = false;
				}
				else if (e.type == MouseEvent.DOUBLE_CLICK)
				{
					// let event propagation itself.
				}
				// Force next click event would not be a double-click event.
				lastClickTarget = null;
			}
			else
			{
				// Not double-click event.
				if (e.type == MouseEvent.DOUBLE_CLICK)
				{
					e.stopImmediatePropagation();
					var clickEvt:MouseEvent = new MouseEvent(MouseEvent.CLICK, true, true, e.localX, e.localY, target, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta);
					pauseClickHandler = true;
					target.dispatchEvent(clickEvt);
					pauseClickHandler = false;
				}
				else if (e.type == MouseEvent.CLICK)
				{
					// let event propagation itself.
				}
				lastClickTime = clickTime;
				lastClickTarget = target;
			}
		}
	
	}
}
package  com.intuitStudio.utils
{
	import flash.utils.getTimer;

	public class GameTimer
	{
		public var gameStartTime:Number = 0.0;
		public var lastFrameTime:Number = 0.0;
		public var currentFrameTime:Number = 0.0;
		public var frameMs:Number = 0.0;
		public var frameCount:uint = 0;
		public var nextHeartbeatTime:uint = 0;
		public var gameElapsedTime:uint = 0;
		public var heartbeatIntervalMs:uint = 1000;
		public var heartbeatFunction:Function;

		public function GameTimer (heartbeatFunc:Function=null,heartbeatMs:uint=1000)
		{
			if (heartbeatFunc != null)
			{
				heartbeatFunction = heartbeatFunc;
			}

			heartbeatIntervalMs = heartbeatMs;
		}
        
		//計算每隔 heartbeatMs 的單位時間
		public function tick ():void
		{
			currentFrameTime = getTimer();

			if (frameCount == 0)
			{
				gameStartTime = currentFrameTime;
				frameMs = 0;
				gameElapsedTime = 0;
			}
			else
			{
				frameMs = currentFrameTime - lastFrameTime;
				gameElapsedTime +=  frameMs;
			}

			if (heartbeatFunction != null)
			{
				if (currentFrameTime >= nextHeartbeatTime)
				{
					heartbeatFunction ();
					nextHeartbeatTime = currentFrameTime + heartbeatIntervalMs;
				}
			}

			lastFrameTime = currentFrameTime;
			frameCount++;
		}

	}//endOfClass

}//endOfPackage
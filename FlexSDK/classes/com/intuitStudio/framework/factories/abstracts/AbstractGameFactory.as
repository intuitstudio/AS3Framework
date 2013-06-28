package com.intuitStudio.framework.factories.abstracts
{
	import com.intuitStudio.framework.interfaces.IGame;
	import com.intuitStudio.framework.interfaces.IGameFactory;
	import flash.utils.getDefinitionByName;
	import flash.errors.IllegalOperationError;

	public class AbstractGameFactory implements IGameFactory
	{
		private var classRef:Class;
		public function AbstractGameFactory(obj:Class)
		{
			classRef = obj;
		}
		
		public function makeGame(coordinate:String):IGame
		{
			var app:IGame = makeInstance(classRef);
			app.coordinate = coordinate;
			return app; 
		}	 
		
		public function makeInstance(classRef:Class):*
		{			
			return new classRef() as IGame;
		}
		
	}
	
}
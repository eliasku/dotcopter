package com.gamingyourway.fps{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class Debug_fps {

//---------------------------------------------------------------------------------------
// Properties
//---------------------------------------------------------------------------------------
		[Embed("_assets/fpsCounter.swf",symbol="FPSCounter")]
		private var fpsSymbol:Class;

		private var fpsHolder:Sprite;
		private var pos:Point;
		private var stage:Stage;

//------------------------------------------------
// Work vars
//------------------------------------------------
		private var frameRate:Number;
		private var lowest:int;
		private var highest:int;
		private var checkCounter:int;
		private var checkRate:int;
		private var lowestResetCnt:int;
		private var startTime:Number;
		
//---------------------------------------------------------------------------------------
//Constructor
//---------------------------------------------------------------------------------------
/**
 * @method Debug_fps
 * @param currentStage - This should be the swf's root timeline
 * @param posArg - A Point for the x/y position of the fps counter
 */
		public function Debug_fps(currentStage:Stage,posArg:Point):void{
			stage=currentStage;
			pos=posArg;

			lowest=frameRate=stage["frameRate"];
			highest=0;
			checkCounter = 1;
			checkRate = 8;
			lowestResetCnt=frameRate*5;
			startTime = getTimer();

			fpsHolder=new fpsSymbol();
			stage.addChild(fpsHolder);
			fpsHolder.x=pos.x;
			fpsHolder.y=pos.y;
			fpsHolder.addEventListener(Event.ENTER_FRAME, mainloop);
		}

//---------------------------------------------------------------------------------------
// Public
//---------------------------------------------------------------------------------------
		public function toString():String {
			return "Debug_fps";
		}		

//---------------------------------------------------------------------------------------
// Private
//---------------------------------------------------------------------------------------
		private function mainloop(event:Event):void{
			if(--checkCounter==0) {
				var fr:Number = checkRate/((getTimer() - startTime)/1000);
				fr=Math.round((fr*10)/10);
				if(fr>frameRate){
					fr=frameRate;
				}
				
				fpsHolder["fps"].text=fr;
				if(fr<lowest){
					lowest=fpsHolder["lowestValue"].text=fr;
				}

				if(fr>highest){
					highest=fr;
				}
	
				startTime = getTimer();
				checkCounter = checkRate;
			}
			if (--lowestResetCnt==0){
				lowest=fpsHolder["lowestValue"].text=highest;
				lowestResetCnt=frameRate*6;
			}
			
			fpsHolder["bar"].height=((fpsHolder["fps"].text/frameRate)*100)/4;

//Ensure this clip is always the highest
			var depth:int=stage.numChildren-1;
			if(stage.getChildIndex(fpsHolder)<depth){
				stage.setChildIndex(fpsHolder,depth);
			}
		}
	}
}
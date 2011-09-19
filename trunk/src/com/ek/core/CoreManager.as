package com.ek.core 
{
	import com.ek.gocs.GameObject;

	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * @author eliasku
	 */
	public class CoreManager 
	{
		static private function keyDownHandler(event:KeyboardEvent):void
		{
			const code:uint = event.keyCode;
			const obj:Object = _keys[code];
			const repeated:Boolean = (obj!=null && obj==true);
			if(!repeated) 
				_keys[code] = true;
			
			var e:CoreKeyboardEvent = new CoreKeyboardEvent(CoreKeyboardEvent.KEY_DOWN);
			e.process(repeated, event);
			_eventDispatcher.dispatchEvent(e);
		}
		
		static private function keyUpHandler(event:KeyboardEvent):void
		{
			const code:uint = event.keyCode;	
			_keys[code] = false;
			
			var e:CoreKeyboardEvent = new CoreKeyboardEvent(CoreKeyboardEvent.KEY_UP);
			e.process(false, event);
			_eventDispatcher.dispatchEvent(e);
		}
		
		static private function mouseMoveHandler(event:MouseEvent):void
		{
			if(_mouseLeaved)
				_mouseLeaved = false;
				
			var e:CoreMouseEvent = new CoreMouseEvent(CoreMouseEvent.MOUSE_MOVE);
			e.x = _mouseX = event.stageX;
			e.y = _mouseY = event.stageY;
			e.leaved = _mouseLeaved;
			
			_eventDispatcher.dispatchEvent(e);
		}
		
		static private function mouseDownHandler(event:MouseEvent):void
		{
			_mousePushed = true;
			
			if(_mouseLeaved)
				mouseMoveHandler(event);
			
			var e:CoreMouseEvent = new CoreMouseEvent(CoreMouseEvent.MOUSE_DOWN);	
			e.x = _mouseX;
			e.y = _mouseY;
			e.leaved = _mouseLeaved;
			
			_eventDispatcher.dispatchEvent(e);
		}
	
		static private function mouseUpHandler(event:MouseEvent):void
		{
			var e:CoreMouseEvent = new CoreMouseEvent(CoreMouseEvent.MOUSE_UP);	
			e.x = _mouseX;
			e.y = _mouseY;
			e.leaved = _mouseLeaved = false;
			
			_eventDispatcher.dispatchEvent(e);
		}
	
		static private function mouseLeaveHandler(event:Event):void
		{
			_mouseLeaved = true;
		}
		
				
		static private function enterFrameHandler(event:Event):void
		{
			const now:int = getTimer();
			const ms:int = now - _last;
			var dt:Number = ms*0.001;
		
			if ( dt > 0.1 ) dt = 0.1;
			
			_rawDeltaTime = ms;
			_deltaTime = dt;
			_last = now;
			++_frames;
			if ( ( now - _fpsLastMeas ) > 1000 )
			{
				_fpsLastMeas = now;
				_fps = _frames;
				_frames = 0;
				
				_eventDispatcher.dispatchEvent(new CoreEvent(CoreEvent.FPS));
			}
			
			_intervalTimer += ms;
			if(_intervalTimer > _intervalRate)
				_eventDispatcher.dispatchEvent(new CoreEvent(CoreEvent.SLOW_TICK));
			
			_eventDispatcher.dispatchEvent(new CoreEvent(CoreEvent.TICK));
		}
		
		// display
		static private var _stage:Stage;
		
		// input
		static private var _mouseX:Number = 0;
		static private var _mouseY:Number = 0;
		static private var _mousePushed:Boolean;
		static private var _mouseLeaved:Boolean;
		static private var _keys:Dictionary = new Dictionary();
		
		// timer
		static private var _deltaTime:Number = 0.001;
		static private var _fps:int;
		static private var _last:int = getTimer();
		static private var _rawDeltaTime:int;
		static private var _frames:int;
		static private var _fpsLastMeas:int = getTimer();
		static private var _intervalTimer:int;
		static private var _intervalRate:int = 200;
		
		static private var _eventDispatcher:EventDispatcher = new EventDispatcher();		
		
		static private var _root:GameObject;
		
		static public function addEventListener(type:String, listener:Function, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_eventDispatcher.addEventListener(type, listener, false, priority, useWeakReference);
		}
		
		static public function removeEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.removeEventListener(type, listener);
		}
		
		static public function initialize(stage:Stage):GameObject
		{
			_stage = stage;
			
			if(!_root)
			 	_root = new RootGameObject(stage);
			 	
			stage.addChild(_root);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			
			//stage.frameRate = 100;
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			
			_mouseX = stage.mouseX;
			_mouseY = stage.mouseY;
			 
			return _root;
		}
				
		static public function get deltaTime():Number
		{
			return _deltaTime;
		}
		
		static public function get fps():uint
		{
			return _fps;
		}
		
		static public function get mouseX():Number
		{
			return _mouseX;
		}
		
		static public function get mouseY():Number
		{
			return _mouseY;
		}
		
		static public function get stage():Stage
		{
			return _stage;
		}
				
		static public function get displayWidth():uint
		{
			if(_stage.displayState == StageDisplayState.FULL_SCREEN)
				return _stage.fullScreenWidth;
			return _stage.stageWidth;
		}
		
		static public function get displayHeight():uint
		{
			if(_stage.displayState == StageDisplayState.FULL_SCREEN)
				return _stage.fullScreenHeight;
			return _stage.stageHeight;
		}
		
		static public function get root():GameObject
		{
			return _root;
		}
		
		static public function get rawDeltaTime():int
		{
			return _rawDeltaTime;
		}
	}
}
import com.ek.core.CoreEvent;
import com.ek.core.CoreManager;
import com.ek.gocs.GameObject;

import flash.display.Stage;

class RootGameObject extends GameObject 
{
	public function RootGameObject(stage:Stage)
	{
		super();
		
		stage.addChild(this);
		
		onRootJoin();
		
		mouseEnabled = 
		mouseChildren = true;
		
		CoreManager.addEventListener(CoreEvent.TICK, onTick, 5000);
		CoreManager.addEventListener(CoreEvent.SLOW_TICK, onSlowTick, 5000);
	}
	
	private function onTick(e:CoreEvent):void
	{
		tick(CoreManager.deltaTime);
	}
	
	private function onSlowTick(e:CoreEvent):void
	{
		slowTick();
	}
}

package com.ek.debug 
{
	import com.bubbler.farm.display.IsoMath;
	import com.bubbler.farm.game.FarmGame;
	import com.bubbler.farm.game.WorldCell;
	import com.ek.core.CoreEvent;
	import com.ek.core.CoreKeyboardEvent;
	import com.ek.core.CoreManager;
	import com.ek.gocs.GameObject;
	import com.ek.ui.minimal.UIMinimalSet;
	import com.ek.utils.Vector2;

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.ui.Keyboard;

	/**
	 * @author eliasku
	 */
	public class Console extends GameObject
	{		
		internal static const INDENT:int = 1;
		internal static const TITLE_HEIGHT:int = 16;
		internal static const INPUT_HEIGHT:int = 16;

		private var _silent:Boolean;

		public function Console(title:String = "Console", width:int = 640, height:int = 384, silent:Boolean = false)
		{
			super();
			
			_silent = silent;
			
			name = "console";
			
			initializeStyleSheet();
			
			_info = new ConsoleInfo(this);
			_panel = new ConsolePanel(this, width, height, title);
			
			Logger.addEventListener(logHandler);
			
			CoreManager.addEventListener(CoreEvent.FPS, fpsHandler);
			CoreManager.addEventListener(CoreKeyboardEvent.KEY_DOWN, keyDownHandler);
			
			addCommand("clear", "Clear the output window.", commandClear);
			addCommand("list", "Prints list of available commands.", commandList);
			addCommand("echo", "Prints something, maybe binded variables in future.", commandEcho);
			
			Logger.message("Welcome! Type LIST to look at available commands.\n");
			
			mouseEnabled = false;
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
			
			_info.tick(dt);
			_panel.tick(dt);
		}
		
		public function get styleSheet():StyleSheet
		{
			return _styleSheet;
		}

		public function addCommand(alias:String, description:String, func:Function, trimArgs:Boolean = true):void
		{
			alias = alias.toUpperCase();
			var command:ConsoleCommand = new ConsoleCommand(alias, description, func, trimArgs);
			_commands.push(command);
		}
		
		public function executeString(commandText:String):void
		{
			var args:Array = extractArguments(commandText);
			var alias:String;
			var command:ConsoleCommand;
			
			if(args.length == 0) return;
			
			alias = (args.shift() as String).toUpperCase();
					
			Logger.message("[execute] " + commandText);
			
			command = findCommand(alias);
			if(command)
			{
				try
				{
					if(command.trimArgs)
						command.func.apply(null, args);
					else
						command.func.apply(null, [commandText.substring(command.alias.length+1)]);
				}
				catch(e:Error)
				{
					Logger.warning("'" + command.alias + "' execution error");			
					Logger.warning(e.name);
					Logger.warning(e.message);
				}
			}
			else
			{
				Logger.message("Command " + alias + " not found. Type LIST to see available commands");
			}
		}

		public function findCommand(alias:String):ConsoleCommand
		{
			for each (var command:ConsoleCommand in _commands)
			{
				if(command.alias == alias)
					return command;
			}
			
			return null;
		}
		
		private function extractArguments(text:String):Array
		{
			var args:Array = text.split(" ");
			var i:int;
			
			while(i < args.length)
			{
				if((args[i] as String).length == 0) args.splice(i, 1);
				else ++i;
			}
			
			return args;
		}
		
		private function commandClear():void
		{
			_panel.clear();
		}
		
		private function commandList():void
		{
			for each (var command:ConsoleCommand in _commands)
				Logger.message(command.alias + " - " + command.desc);
		}
		
		private function commandEcho(...args):void
		{
			Logger.message("[echo] " + args.join(" "));
		}
		
		private function logHandler(e:LogEvent):void
		{
			if(!_silent)
				_panel.print("<span class=\"" + e.level + "\">" + e.message + "</span><br>");
		}

		private function keyDownHandler(e:CoreKeyboardEvent):void
		{
			if(e.repeated) return;
			
			switch(e.code)
			{
				case Keyboard.F1:
					if(_info.shown) _info.hide();
					else _info.show();
					break;
				case Keyboard.F2:
					if(_panel.shown) _panel.hide();
					else _panel.show();
					break;
				case Keyboard.F3:
					Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, Logger.history, false);
					break;
			}
		}
		
		private function fpsHandler(e:Event):void
		{
			_info.text = "FPS: " + CoreManager.fps.toString() + "\nMEM: " + int(System.totalMemory / 1000000) + " MB\nGPU: " + CoreManager.stage.wmodeGPU;
			
/*			if (FarmGame.instance)
			{
				var V:Vector2 = new Vector2();
				
				IsoMath.screenToTile(FarmGame.instance.back.mouseX, FarmGame.instance.back.mouseY - FarmGame.BG_OFFSET_Y, V);
				
				var cell:WorldCell = FarmGame.instance.world.grid.getAreaCell(int(V.x), int(V.y));
				if (cell)
				{
					_info.text += "\ncell: " + int(V.x) + " " + int(V.y);
					_info.text += "\nfree: " + cell.free;
				}
			}*/
		}
		
		private function initializeStyleSheet():void
		{
			_styleSheet.clear();
			
			var log_message_request:Object = { color:"#EEA600" };
			var log_message_response:Object = { color:"#5EFFBE" };
			var log_message:Object = { color:"#FFFFFF" };
			var log_warning:Object = { color:"#FFFF22" };
			var log_error:Object = { color:"#FF0000" };
			var log_info:Object = { color:"#77FF77" };
            
			_styleSheet.setStyle("body", UIMinimalSet.getStyleObject());
			_styleSheet.setStyle(".log_rpc_request", log_message_request);
			_styleSheet.setStyle(".log_rpc_response", log_message_response);
			_styleSheet.setStyle(".log_message", log_message);
			_styleSheet.setStyle(".log_warning", log_warning);
			_styleSheet.setStyle(".log_error", log_error);
			_styleSheet.setStyle(".log_info", log_info);
		}

		private var _info:ConsoleInfo;
		private var _panel:ConsolePanel;
		
		private var _commands:Vector.<ConsoleCommand> = new Vector.<ConsoleCommand>();

		private var _styleSheet:StyleSheet = new StyleSheet();
		
		private static var _proxy:Console;
		public static function get proxy():Console { return _proxy; }
		
		public static function createProxy(title:String, width:int = 640, height:int = 384, silent:Boolean = false):void
		{
			if(!_proxy)
			{
				_proxy = new Console(title, width, height, silent);
				if(!silent)
					CoreManager.root.addChild(_proxy);
			}
		}

	}
}
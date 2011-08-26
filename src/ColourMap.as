package 
{
    import flash.display.*;
    import flash.geom.*;
    
    public class ColourMap extends flash.display.Sprite
    {
        public function ColourMap()
        {
            _recursions = 0;
            _ball_rot = 10;
            _ball_speed = 8;
            _ball_sprite = new flash.display.Sprite();
            _mask_colour = 4294967295;
            _hit_colour = 4294967040;
            iteration_count = 0;
            _test_sprite = new flash.display.Sprite();
            super();
            return;
        }

        private function copyParamsFromTo(arg1:flash.display.Sprite, arg2:flash.display.Sprite):void
        {
            arg2.x = arg1.x;
            arg2.y = arg1.y;
            arg2.rotation = arg1.rotation;
            return;
        }

        public function init(arg1:flash.display.DisplayObject, arg2:flash.display.Sprite, arg3:Boolean=false):void
        {
            _game_stage = arg1.stage;
            _debug = arg3;
            _colour_map = arg2;
            addChild(_colour_map);
            return;
        }

        public function initBall(arg1:Number, arg2:Number, arg3:flash.geom.Point=null):void
        {
            _ball_radius = arg1;
            _restitution = arg2;
            _view_box = Math.ceil(_ball_radius * 2);
            _box_centre = new flash.geom.Point(_view_box * 0.5, _view_box * 0.5);
            _map_bmd = new flash.display.BitmapData(_view_box, _view_box, false, 4278190335);
            _map_bmd.draw(_colour_map, null, null, null, new flash.geom.Rectangle(0, 0, _view_box, _view_box));
            _ball_sprite.graphics.beginFill(65280);
            _ball_sprite.graphics.drawCircle(0, 0, _ball_radius);
            _ball_sprite.graphics.endFill();
            _ball_sprite.blendMode = flash.display.BlendMode.ADD;
            if (!arg3)
            {
                arg3 = new flash.geom.Point(_colour_map.width * 0.5, _colour_map.height * 0.5);
            }
            _ball_sprite.x = arg3.x;
            _ball_sprite.y = arg3.y;
            _ball_sprite.rotation = _ball_rot;
            addChild(_ball_sprite);
            if (_debug)
            {
                _test_sprite.graphics.beginFill(255);
                _test_sprite.graphics.drawCircle(0, 0, 2);
                _test_sprite.graphics.endFill();
                addChild(new flash.display.Bitmap(_map_bmd));
                addChild(_test_sprite);
                _game_stage.addChild(this);
            }
            return;
        }

        public function getColourFromMap(arg1:flash.geom.Point):uint
        {
            return _map_bmd.getPixel(arg1.x, arg1.y);
        }

        private function distanceToPoint(arg1:flash.geom.Point, arg2:flash.geom.Point):Number
        {
            var loc1:*;
            loc1 = NaN;
            var loc2:*;
            loc2 = NaN;
            var loc3:*;
            loc3 = NaN;
            loc1 = arg1.x - arg2.x;
            loc2 = arg1.y - arg2.y;
            return loc3 = Math.sqrt(loc1 * loc1 + loc2 * loc2);
        }

        private function getMatrixTransform():flash.geom.Matrix
        {
            var loc1:*;
            loc1 = null;
            loc1 = new flash.geom.Matrix();
            loc1.tx = -(_ball_sprite.x - _view_box * 0.5);
            loc1.ty = -(_ball_sprite.y - _view_box * 0.5);
            return loc1;
        }

        private function angleToPoint(arg1:flash.geom.Point, arg2:flash.geom.Point):Number
        {
            var loc1:*;
            loc1 = NaN;
            var loc2:*;
            loc2 = NaN;
            loc1 = arg2.x - arg1.x;
            loc2 = arg2.y - arg1.y;
            return Math.atan2(loc2, loc1) * TO_DEGREES;
        }

        public function iterateBall(arg1:flash.display.Sprite, arg2:Number):Number
        {
            _ball_speed = arg2;
            copyParamsFromTo(arg1, _ball_sprite);
            moveForward(_ball_sprite, arg2);
            _recursions = 0;
            if (calculaterBallPath())
            {
                _ball_speed = _ball_speed * _restitution;
            }
            copyParamsFromTo(_ball_sprite, arg1);
            if (_debug)
            {
                copyParamsFromTo(_ball_sprite, _test_sprite);
            }
            return _ball_speed;
        }

        private function calculaterBallPath():Boolean
        {
            var loc1:*;
            loc1 = NaN;
            var loc2:*;
            loc2 = null;
            var loc3:*;
            loc3 = null;
            var loc4:*;
            loc4 = NaN;
            var loc5:*;
            loc5 = undefined;
            var loc6:*;
            var loc7:*;
            _recursions++;
            loc1 = _ball_sprite.rotation;
            _map_bmd.draw(this, getMatrixTransform(), null, null, new flash.geom.Rectangle(0, 0, _view_box, _view_box));
            loc2 = _map_bmd.getColorBoundsRect(_mask_colour, _hit_colour, true);
            if (loc2.width > 0 && loc2.height > 0)
            {
                loc3 = new flash.geom.Point(loc2.x + loc2.width * 0.5, loc2.y + loc2.height * 0.5);
                loc4 = _ball_radius - distanceToPoint(_box_centre, loc3);
                moveBackward(_ball_sprite, loc4);
                loc5 = angleToPoint(loc3, _box_centre);
                _ball_sprite.rotation = loc5 + loc5 - loc1;
                if (_recursions < MAX_RECURSIONS)
                {
                    moveForward(_ball_sprite, loc4);
                    calculaterBallPath();
                }
                return true;
            }
            return false;
        }

        private function moveForward(arg1:flash.display.Sprite, arg2:Number):void
        {
            var loc1:*;
            loc1 = NaN;
            var loc2:*;
            loc2 = NaN;
            var loc3:*;
            loc3 = NaN;
            loc1 = arg1.rotation * TO_RADIANS;
            loc2 = arg1.x + arg2 * Math.sin(loc1);
            loc3 = arg1.y - arg2 * Math.cos(loc1);
            arg1.x = loc2;
            arg1.y = loc3;
            return;
        }

        private function moveBackward(arg1:flash.display.Sprite, arg2:*):void
        {
            arg1.rotation = arg1.rotation - 180;
            moveForward(arg1, arg2);
            arg1.rotation = arg1.rotation + 180;
            return;
        }

        private const MAX_RECURSIONS:int=10;

        private const TO_DEGREES:Number=57.2957795131;

        private const TO_RADIANS:Number=0.0174532925199;

        private var _colour_map:flash.display.Sprite;

        private var _ball_radius:Number;

        private var iteration_count:int=0;

        private var _debug:Boolean;

        private var _test_sprite:flash.display.Sprite;

        private var _box_centre:flash.geom.Point;

        private var _ball_sprite:flash.display.Sprite;

        private var _view_box:int;

        private var _hit_colour:uint=4294967040;

        private var _ball_speed:Number=8;

        private var _restitution:Number;

        private var _mask_colour:uint=4294967295;

        private var _map_bmd:flash.display.BitmapData;

        private var _recursions:int=0;

        private var _ball_rot:Number=10;

        private static var _game_stage:flash.display.Stage;
    }
}

// UTILS UTILS UTILS

package utils 
{
    import flash.geom.Point;
    
    public class GameMaths extends Object
    {
        public static const TO_DEGREES:Number = 57.2957795131;
        public static const TO_RADIANS:Number = 0.0174532925199;
		
		public static function angleToPoint(p1:Point, p2:Point):Number
        {
            var dx:Number = p2.x - p1.x;
            var dy:Number = p2.y - p1.y;
            return Math.atan2(dy, dx) * 180 / Math.PI;
        }

        public static function moveForward(target:*, distance:Number, angle:Number=99999):void
        {
            if (angle == 99999)
            {
                angle = target.rotation;
            }
            var theta:Number = angle * Math.PI / 180;
			
            var dx:Number = target.x + distance * Math.sin(theta);
            var dy:Number = target.y - distance * Math.cos(theta);
			
            target.x = dx;
            target.y = dy;
            return;
        }

        public static function distanceFromTo(p1:Point, p2:Point):Number
        {
            var dx:Number = p1.x - p2.x;
            var dy:Number = p1.y - p2.y;
            return Math.sqrt(dx * dx + dy * dy);
        }
    }
}


//  class ColourMapTest
package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import swingpants.colourmapbounce.*;
    import swingpants.utils.*;
    
    public class ColourMapTest extends flash.display.MovieClip
    {
        public function ColourMapTest()
        {
            _radius = 14;
            _restitution = 0.9;
            _friction = 0.98;
            _max_speed = 12;
            _ball_speed = _max_speed;
            super();
            addFrameScript(0, frame1);
            _ball_sprite = new Ball();
            var loc1:*;
            _ball_sprite.height = loc1 = _radius * 2;
            _ball_sprite.width = loc1;
            _ball_sprite.x = 480;
            _ball_sprite.y = 250;
            _ball_sprite.rotation = Math.random() * 360;
            _ball_sprite.buttonMode = true;
            _ball_sprite.addEventListener(flash.events.MouseEvent.CLICK, mouseClickHandler);
            _colour_map = new swingpants.colourmapbounce.ColourMap();
            _colour_map.init(this, new Scene2_ColourMap(), false);
            _colour_map.initBall(_radius, _restitution);
            addChild(new Scene2());
            addChild(_ball_sprite);
            addEventListener(flash.events.Event.ENTER_FRAME, update);
            return;
        }

        function frame1():*
        {
            return;
        }

        private function update(arg1:flash.events.Event):void
        {
            if (_ball_speed > 0.1)
            {
                _ball_speed = _ball_speed * _friction;
                _ball_speed = _colour_map.iterateBall(_ball_sprite, _ball_speed);
            }
            else 
            {
                _ball_sprite["ball"].pattern.gotoAndStop(1);
            }
            return;
        }

        private function mouseClickHandler(arg1:flash.events.MouseEvent):void
        {
            _ball_sprite.rotation = swingpants.utils.GameMaths.angleToPoint(new flash.geom.Point(this.mouseX, this.mouseY), new flash.geom.Point(_ball_sprite.x, _ball_sprite.y)) + 90;
            _ball_speed = _max_speed;
            _ball_sprite["ball"].pattern.gotoAndPlay(1);
            return;
        }

        private var _colour_map:swingpants.colourmapbounce.ColourMap;

        private var _max_speed:Number=12;

        private var _friction:Number=0.98;

        private var _ball_sprite:flash.display.Sprite;

        private var _ball_speed:Number;

        private var _radius:int=14;

        private var _restitution:Number=0.9;
    }
}
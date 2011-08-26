// forked from cleoag's Bitmap Terrain
package {
    import flash.system.LoaderContext;
    import flash.net.URLRequest;
    import flash.display.LoaderInfo;
    import flash.display.Loader;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.filters.BevelFilter;
    import flash.display.Bitmap;
    import flash.filters.GlowFilter;
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.Sprite;
    
    /**
     * Old flash8 experiment with terrain generation
     * den ivanov (cleoag.ru)
     */

   [SWF(width = 465, height = 465, frameRate = 60,backgroundColor=0x000000)]
   public class BitmapTerrain extends Sprite {
       private var f:GlowFilter;
       private var l:Number=0;
       private var scale:Number=2;
       private var screenBmp:BitmapData;
       private var heightBmp:BitmapData;
       private var terrainBmp:BitmapData;
       private var noiseBmp:BitmapData;    
       private var gradients:Vector.<BitmapData>, gindex:int;
        
       public function BitmapTerrain () {
            gradients = new Vector.<BitmapData> (2, true);
            var loader:Loader = new Loader;
            loader.contentLoaderInfo.addEventListener (Event.COMPLETE, onLoaded1);
            loader.load (new URLRequest ("http://assets.wonderfl.net/images/related_images/d/d0/d08b/d08b1d7841d9f2b009adcb6352e790997ad6b346"),
                new LoaderContext (true));
       }

       public function onLoaded1 (e:Event):void {
            var info:LoaderInfo = LoaderInfo (e.target);
            gradients [0] = Bitmap (info.content).bitmapData;
            var loader:Loader = new Loader;
            loader.contentLoaderInfo.addEventListener (Event.COMPLETE, onLoaded2);
            loader.load (new URLRequest ("http://assets.wonderfl.net/images/related_images/8/8b/8b9e/8b9edba3f29c2e46ea3c2d5891150db76abb6159"),
                new LoaderContext (true));
       }

       public function onLoaded2 (e:Event):void {
            var info:LoaderInfo = LoaderInfo (e.target);
            gradients [1] = Bitmap (info.content).bitmapData;
            stage.scaleMode="noScale";
            stage.frameRate = 60;
			
            screenBmp=new BitmapData(1024,768,true,0x0);
            heightBmp=new BitmapData(256*scale,256*scale,false,0x0);
            terrainBmp=new BitmapData(256*scale,256*scale,true,0x0);
            noiseBmp=new BitmapData(256*scale,256*scale,true,0x0);
            noiseBmp.noise(Math.random()*1000,0,255,4,true);
            addChild(new Bitmap(screenBmp));
            heightBmp.perlinNoise(150, 150, 5, Math.random()*1000, false, true,4, false);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
            addEventListener(Event.ENTER_FRAME, redrawTerrain);
        }

        private function fadeColor(startColor:Number, pers:Number):Number {
            var sR:Number = Math.min(255,Math.max(0,pers+ (startColor >> 16)));
            var sG:Number = Math.min(255,Math.max(0,pers+ ((startColor & 0x00FF00) >> 8)));
            var sB:Number = Math.min(255,Math.max(0,pers+ ((startColor & 0x0000FF))));
            return (sR << 16 | sG << 8 | sB);
        }
        private function redrawTerrain(event:Event):void {
            terrainBmp.lock();
            for (var i:int = 0; i<8; i++) {
                terrainBmp.fillRect(terrainBmp.rect,0x0);
                //var color:Number= l << 16 | l << 8 | l; 
               //var color:Number = gradients[gindex].getPixel(l,0);
                terrainBmp.threshold(heightBmp,heightBmp.rect, new Point(),">",0xFF000000+l,0xFF000000+color,0x00ffffff,false);
                var bf:BevelFilter=new BevelFilter(4,45,fadeColor(color,50),1,fadeColor(color,-50),1,10,10,1,1,"inner",false);
                terrainBmp.applyFilter(terrainBmp,terrainBmp.rect,new Point(),bf);
                screenBmp.draw(terrainBmp, new Matrix (1, -0.5, 1, 0.5, 10, 457-l));
                l+=1;
                if (l>255) {
                    terrainBmp.unlock();
                    removeEventListener(Event.ENTER_FRAME, redrawTerrain);
                }
            }
        terrainBmp.unlock();
        }
        private function mouseUp(evt:MouseEvent):void {
                    gindex = 1 - gindex;
            screenBmp.fillRect(screenBmp.rect,0x0);
            heightBmp.perlinNoise(150, 150, 5, Math.random()*1000, false, true,4, false);
            addEventListener(Event.ENTER_FRAME, redrawTerrain);
            l=0;
        }
        private function mouseDown(evt:MouseEvent):void {
            removeEventListener(Event.ENTER_FRAME, redrawTerrain);
        }
    }
}
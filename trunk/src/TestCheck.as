package
{
	import com.aberustudios.ui.CheckBox;
	
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	public class TestCheck extends CheckBox
	{
		public function TestCheck(x:Number=0, y:Number=0, text:String="", callback:Function=null)
		{
			var t:Text = new Text(text);
			var t2:Text = new Text(text);
			var t3:Text = new Text(text);
			
			t.x = t2.x = t3.x = 15;
			t2.color = 0xFF99CC;
			t3.color = 0x999999;
			
			var a:Image = Image.createRect(12, 12, 0xFF66CC);
			var a2:Image = Image.createRect(12, 12, 0xFF99CC);
			var a3:Image = Image.createRect(12, 12, 0x666666);
			
			var b:Image = Image.createRect(4, 4, 0xFF99CC);
			var b2:Image = Image.createRect(4, 4, 0xFFCCCC);
			var b3:Image = Image.createRect(4, 4, 0x333333);
			
			b.x = b2.x = b3.x = b.y = b2.y = b3.y = 4;
			
			super(x, y, t.width, t.height, callback);
			
			normal = new Graphiclist(a, t);
			hover = new Graphiclist(a2, t2);
			down = normal;
			inactive = new Graphiclist(a3, t3);
			
			normalChecked = new Graphiclist(a, b, t);
			hoverChecked = new Graphiclist(a2, b2, t2);
			downChecked = normalChecked;
			inactiveChecked = new Graphiclist(a3, b3, t3);
		}
	}
}
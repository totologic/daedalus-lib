package
{
	import DDLS.data.DDLSMesh;
	import DDLS.data.DDLSObject;
	import DDLS.factories.DDLSBitmapObjectFactory;
	import DDLS.factories.DDLSRectMeshFactory;
	import DDLS.view.DDLSSimpleView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	[SWF(width="600", height="600")]
	public class DemoFromBitmap extends Sprite
	{
		
		private var _mesh:DDLSMesh;
		private var _view:DDLSSimpleView;
		private var _object:DDLSObject;
		
		[Embed(source="DemoFromBitmap.png")]
		private var BmpClass:Class;
		private var _bmp:Bitmap;
		
		public function DemoFromBitmap()
		{
			// build a rectangular 2 polygons mesh of 600x600
			_mesh = DDLSRectMeshFactory.buildRectangle(600, 600);
			
			// show the source bmp
			_bmp = new BmpClass();
			_bmp.x = 110;
			_bmp.y = 220;
			addChild(_bmp);
			
			
			// create a viewport
			_view = new DDLSSimpleView();
			addChild(_view.surface);
			
			
			// create an object from bitmap
			_object = DDLSBitmapObjectFactory.buildFromBmpData(_bmp.bitmapData);
			_object.x = 110;
			_object.y = 220;
			_mesh.insertObject(_object);
			
			
			// display result mesh
			_view.drawMesh(_mesh);
		}
	}
}
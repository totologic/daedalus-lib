package
{
	import DDLS.data.math.DDLSTools;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	[SWF(width="600", height="600")]
	public class DemoMeshExtractionFromBitmap extends Sprite
	{
		
		[Embed(source="DemoMeshExtractionFromBitmap.png")]
		private var BmpClass:Class;
		private var _bmp:Bitmap;
		
		public function DemoMeshExtractionFromBitmap()
		{
			
			// show the source bmp
			_bmp = new BmpClass();
			_bmp.x = 200;
			_bmp.y = 200;
			addChild(_bmp);
			
			// 2 containers to store result of extraction
			var vertices:Vector.<Point> = new Vector.<Point>();
			var triangles:Vector.<int> = new Vector.<int>();
			
			// extraction !
			DDLSTools.extractMeshFromBitmap(_bmp.bitmapData, vertices, triangles);
			
			// now we can draw the mesh on screen
			var screenMesh:Sprite = new Sprite();
			addChild(screenMesh);
			screenMesh.x = 200;
			screenMesh.y = 200;
			screenMesh.graphics.lineStyle(1, 0xFF0000);
			for (var i:int=0 ; i<triangles.length ; i+=3)
			{
				screenMesh.graphics.moveTo(vertices[triangles[i]].x, vertices[triangles[i]].y);
				screenMesh.graphics.lineTo(vertices[triangles[i+1]].x, vertices[triangles[i+1]].y);
				screenMesh.graphics.lineTo(vertices[triangles[i+2]].x, vertices[triangles[i+2]].y);
				screenMesh.graphics.lineTo(vertices[triangles[i]].x, vertices[triangles[i]].y);
			}
			
		}
	}
}
package DDLS.factories
{
	import DDLS.data.DDLSObject;
	import DDLS.data.graph.DDLSGraph;
	import DDLS.data.math.DDLSPotrace;
	
	import flash.display.BitmapData;
	import flash.display.Shape;

	public class DDLSBitmapObjectFactory
	{
		
		public static function buildFromBmpData(bmpData:BitmapData
												, debugBmp:BitmapData=null
												, debugShape:Shape=null):DDLSObject
		{	
			var i:int;
			var j:int;
			
			// OUTLINES STEP-LIKE SHAPES GENERATION
			var shapes:Vector.<Vector.<Number>> = DDLSPotrace.buildShapes(bmpData, debugBmp, debugShape);
			
			// GRAPHS OF POTENTIAL SEGMENTS GENERATION
			var graphs:Vector.<DDLSGraph> = new Vector.<DDLSGraph>();
			for (i=0 ; i<shapes.length ; i++)
			{
				graphs.push( DDLSPotrace.buildGraph(shapes[i]) );
			}
			
			// OPTIMIZED POLYGONS GENERATION
			var polygons:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			for (i=0 ; i<graphs.length ; i++)
			{
				polygons.push( DDLSPotrace.buildPolygon(graphs[i], debugShape) );
			}
			
			// OBJECT GENERATION
			var obj:DDLSObject = new DDLSObject();
			for (i=0 ; i<polygons.length ; i++)
			{
				for (j=0 ; j<polygons[i].length-2 ; j+=2)
					obj.coordinates.push(polygons[i][j], polygons[i][j+1], polygons[i][j+2], polygons[i][j+3]);
				obj.coordinates.push(polygons[i][0], polygons[i][1], polygons[i][j], polygons[i][j+1]);
			}
			
			return obj;
		}
		
	}
}
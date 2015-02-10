package DDLS.data.math
{
	import DDLS.data.DDLSConstraintSegment;
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSFace;
	import DDLS.data.DDLSMesh;
	import DDLS.data.DDLSVertex;
	import DDLS.data.graph.DDLSGraph;
	import DDLS.factories.DDLSRectMeshFactory;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	final public class DDLSTools
	{
		
		static public function extractMeshFromBitmap(bmpData:BitmapData, vertices:Vector.<Point>, triangles:Vector.<int>):void
		{
			var i:int;
			var j:int;
			
			// OUTLINES STEP-LIKE SHAPES GENERATION
			var shapes:Vector.<Vector.<Number>> = DDLSPotrace.buildShapes(bmpData);
			
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
				polygons.push( DDLSPotrace.buildPolygon(graphs[i]));
			}
			
			// MESH GENERATION
			var mesh:DDLSMesh = DDLSRectMeshFactory.buildRectangle(bmpData.width, bmpData.height);
			var edges:Vector.<DDLSEdge> = new Vector.<DDLSEdge>(); // WE KEEP TRACK OF 1 EDGE BY SHAPE
			var segment:DDLSConstraintSegment;
			for (i=0 ; i<polygons.length ; i++)
			{
				for (j=0 ; j<polygons[i].length-2 ; j+=2)
				{
					segment = mesh.insertConstraintSegment(polygons[i][j], polygons[i][j+1], polygons[i][j+2], polygons[i][j+3]);
					if (j==0)
					{
						if (segment.edges[0].originVertex.pos.x == polygons[i][j] && segment.edges[0].originVertex.pos.y == polygons[i][j+1])
							edges.push(segment.edges[0]);
						else
							edges.push(segment.edges[0].oppositeEdge);
					}
				}
				mesh.insertConstraintSegment(polygons[i][0], polygons[i][1], polygons[i][j], polygons[i][j+1]);
			}
			
			// FINAL EXTRACTION
			var indicesDict:Dictionary = new Dictionary();
			var vertex:DDLSVertex;
			var point:Point;
			for (i=0 ; i<mesh.__vertices.length ; i++)
			{
				vertex = mesh.__vertices[i];
				if (vertex.isReal
					&& vertex.pos.x > 0 && vertex.pos.x < bmpData.width
					&& vertex.pos.y > 0 && vertex.pos.y < bmpData.height)
				{
					point = new Point(vertex.pos.x, vertex.pos.y);
					vertices.push(point);
					indicesDict[vertex] = vertices.length-1;
				}
			}
			
			var facesDone:Dictionary = new Dictionary();
			var openFacesList:Vector.<DDLSFace> = new Vector.<DDLSFace>();
			for (i=0 ; i<edges.length ; i++)
			{
				openFacesList.push(edges[i].rightFace);
			}
			var currFace:DDLSFace;
			while (openFacesList.length > 0)
			{
				currFace = openFacesList.pop();
				if (facesDone[currFace])
					continue;
				
				triangles.push(indicesDict[currFace.edge.originVertex]);
				triangles.push(indicesDict[currFace.edge.nextLeftEdge.originVertex]);
				triangles.push(indicesDict[currFace.edge.nextLeftEdge.destinationVertex]);
				
				if (! currFace.edge.isConstrained)
					openFacesList.push(currFace.edge.rightFace);
				if (! currFace.edge.nextLeftEdge.isConstrained)
					openFacesList.push(currFace.edge.nextLeftEdge.rightFace);
				if (! currFace.edge.prevLeftEdge.isConstrained)
					openFacesList.push(currFace.edge.prevLeftEdge.rightFace);
				
				facesDone[currFace] = true;
			}
		}
		
	}
}
package DDLS.data.math
{
	import DDLS.data.DDLSConstants;
	import DDLS.data.graph.DDLSGraph;
	import DDLS.data.graph.DDLSGraphEdge;
	import DDLS.data.graph.DDLSGraphNode;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class DDLSPotrace
	{
	
		public static var maxDistance:Number = 1;
		
		public static function buildShapes(bmpData:BitmapData
											, debugBmp:BitmapData=null
											  , debugShape:Shape=null):Vector.<Vector.<Number>>
		{
			// OUTLINES STEP-LIKE SHAPES GENERATION
			var shapes:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
			var dictPixelsDone:Dictionary = new Dictionary();
			for (var row:int=1 ; row<bmpData.height-1 ; row++)
			{
				for (var col:int=0 ; col<bmpData.width-1 ; col++)
				{
					if (bmpData.getPixel(col, row) == 0xFFFFFF && bmpData.getPixel(col+1, row) < 0xFFFFFF)
					{
						if (!dictPixelsDone[(col+1) + "_" + row])
							shapes.push( buildShape(bmpData, row, col+1, dictPixelsDone, debugBmp, debugShape) );
					}
				}
			}
			
			return shapes;
		}
		
		public static function buildShape(bmpData:BitmapData, fromPixelRow:int, fromPixelCol:int, dictPixelsDone:Dictionary
										   , debugBmp:BitmapData=null, debugShape:Shape=null):Vector.<Number>
		{
			var path:Vector.<Number> = new Vector.<Number>();
			var newX:Number = fromPixelCol;
			var newY:Number = fromPixelRow;
			path.push(newX, newY);
			dictPixelsDone[newX + "_" + newY] = true;
			
			var curDir:Point = new Point(0, 1);
			var newDir:Point = new Point();
			var newPixelRow:int;
			var newPixelCol:int;
			var count:int = -1;
			while (true)
			{
				if (debugBmp)
				{
					debugBmp.setPixel32(fromPixelCol, fromPixelRow, 0xFFFF0000);
				}
				
				// take the pixel at right
				newPixelRow = fromPixelRow + curDir.x + curDir.y;
				newPixelCol = fromPixelCol + curDir.x - curDir.y;
				// if the pixel is not white
				if (bmpData.getPixel(newPixelCol, newPixelRow) < 0xFFFFFF)
				{
					// turn the direction right
					newDir.x = -curDir.y;
					newDir.y = curDir.x;
				}
					// if the pixel is white
				else
				{
					// take the pixel straight
					newPixelRow = fromPixelRow + curDir.y;
					newPixelCol = fromPixelCol + curDir.x;
					// if the pixel is not white
					if (bmpData.getPixel(newPixelCol, newPixelRow) < 0xFFFFFF)
					{
						// the direction stays the same
						newDir.x = curDir.x;
						newDir.y = curDir.y;
					}
						// if the pixel is white
					else
					{
						// pixel stays the same
						newPixelRow = fromPixelRow;
						newPixelCol = fromPixelCol;
						// turn the direction left
						newDir.x = curDir.y;
						newDir.y = -curDir.x;
					}
				}
				newX = newX + curDir.x;
				newY = newY + curDir.y;
				
				if (newX == path[0] && newY == path[1])
				{
					break;
				}
				else
				{
					path.push(newX);
					path.push(newY);
					dictPixelsDone[newX + "_" + newY] = true;
					fromPixelRow = newPixelRow;
					fromPixelCol = newPixelCol;
					curDir.x = newDir.x;
					curDir.y = newDir.y;
				}
				
				count--;
				if (count == 0)
				{
					break;
				}
			}
			
			if (debugShape)
			{
				debugShape.graphics.lineStyle(0.5, 0x00FF00);
				debugShape.graphics.moveTo(path[0], path[1]);
				for (var i:int=2 ; i<path.length ; i+=2)
				{
					debugShape.graphics.lineTo(path[i], path[i+1]);
				}
				debugShape.graphics.lineTo(path[0], path[1]);
			}
			
			return path;
		}
		
		public static function buildGraph(shape:Vector.<Number>):DDLSGraph
		{
			var i:int;
			var graph:DDLSGraph = new DDLSGraph();
			var node:DDLSGraphNode;
			for (i=0 ; i<shape.length ; i+=2)
			{
				node = graph.insertNode();
				node.data = new NodeData();
				NodeData(node.data).index = i;
				NodeData(node.data).point = new DDLSPoint2D(shape[i], shape[i+1]);
			}
			
			var node1:DDLSGraphNode;
			var node2:DDLSGraphNode;
			var subNode:DDLSGraphNode;
			var distSqrd:Number;
			var sumDistSqrd:Number;
			var count:int;
			var isValid:Boolean;
			var edge:DDLSGraphEdge;
			var edgeData:EdgeData;
			node1 = graph.node;
			while (node1)
			{
				node2 = node1.next ? node1.next : graph.node;
				while (node2 != node1)
				{
					isValid = true;
					subNode = node1.next ? node1.next : graph.node;
					count = 2;
					sumDistSqrd = 0;
					while (subNode != node2)
					{
						distSqrd = DDLSGeom2D.distanceSquaredPointToSegment(NodeData(subNode.data).point.x, NodeData(subNode.data).point.y
																			, NodeData(node1.data).point.x, NodeData(node1.data).point.y
																			, NodeData(node2.data).point.x, NodeData(node2.data).point.y);
						if (distSqrd < 0)
							distSqrd= 0;
						if (distSqrd >= maxDistance)
						{
							//subNode not valid
							isValid = false;
							break;
						}
						
						count++;
						sumDistSqrd += distSqrd;
						subNode = subNode.next ? subNode.next : graph.node;
					}
					
					if (! isValid)
					{
						//segment not valid
						break;
					}
					
					edge = graph.insertEdge(node1, node2);
					edgeData = new EdgeData();
					edgeData.sumDistancesSquared = sumDistSqrd;
					edgeData.length = NodeData(node1.data).point.distanceTo(NodeData(node2.data).point);
					edgeData.nodesCount = count;
					edge.data = edgeData;
					
					node2 = node2.next ? node2.next : graph.node;
				}
				
				node1 = node1.next;
			}
			
			return graph;
		}
		
		public static function buildPolygon(graph:DDLSGraph, debugShape:Shape=null):Vector.<Number>
		{
			var polygon:Vector.<Number> = new Vector.<Number>();
			
			var currNode:DDLSGraphNode;
			var minNodeIndex:int = int.MAX_VALUE;
			var edge:DDLSGraphEdge;
			var score:Number;
			var higherScore:Number;
			var lowerScoreEdge:DDLSGraphEdge;
			currNode = graph.node;
			while (NodeData(currNode.data).index < minNodeIndex)
			{
				minNodeIndex = NodeData(currNode.data).index;
				
				polygon.push(NodeData(currNode.data).point.x, NodeData(currNode.data).point.y);
				
				higherScore = Number.MIN_VALUE;
				edge = currNode.outgoingEdge;
				while (edge)
				{
					score = EdgeData(edge.data).nodesCount - EdgeData(edge.data).length*Math.sqrt(EdgeData(edge.data).sumDistancesSquared/(EdgeData(edge.data).nodesCount));
					if (score > higherScore)
					{
						higherScore = score;
						lowerScoreEdge = edge;
					}
					
					edge = edge.rotNextEdge;
				}
				
				currNode = lowerScoreEdge.destinationNode;
			}
			
			if (DDLSGeom2D.getDirection(polygon[polygon.length-2], polygon[polygon.length-1], polygon[0], polygon[1], polygon[2], polygon[3]) == 0)
			{
				polygon.shift();
				polygon.shift();
			}
			
			if (debugShape)
			{
				debugShape.graphics.lineStyle(0.5, 0x0000FF);
				debugShape.graphics.moveTo(polygon[0], polygon[1]);
				for (var i:int=2 ; i<polygon.length ; i+=2)
				{
					debugShape.graphics.lineTo(polygon[i], polygon[i+1]);
				}
				debugShape.graphics.lineTo(polygon[0], polygon[1]);
			}
			
			return polygon;
		}
	
	}
}
import DDLS.data.math.DDLSPoint2D;

class EdgeData
{
	public var sumDistancesSquared:Number;
	public var length:Number;
	public var nodesCount:int;
	
	public function EdgeData()
	{
		
	}
}

class NodeData
{
	public var index:int;
	public var point:DDLSPoint2D;
	
	public function NodeData()
	{
		
	}
}
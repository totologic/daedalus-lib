package DDLS.ai
{
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSFace;
	import DDLS.data.DDLSMesh;
	import DDLS.data.DDLSVertex;
	import DDLS.data.math.DDLSGeom2D;
	import DDLS.data.math.DDLSPoint2D;
	import DDLS.iterators.IteratorFromFaceToInnerEdges;
	
	import flash.utils.Dictionary;
	
	public class DDLSAStar
	{
		
		private var _mesh:DDLSMesh;
		
		
		private var __closedFaces:Dictionary;
		private var __sortedOpenedFaces:Vector.<DDLSFace>;
		private var __openedFaces:Dictionary;
		private var __entryEdges:Dictionary;
		private var __entryX:Dictionary;
		private var __entryY:Dictionary;
		private var __scoreF:Dictionary;
		private var __scoreG:Dictionary;
		private var __scoreH:Dictionary;
		private var __predecessor:Dictionary;
		
		private var __iterEdge:IteratorFromFaceToInnerEdges;
		
		private var _radius:Number;
		private var _radiusSquared:Number;
		private var _diameter:Number;
		private var _diameterSquared:Number;
		
		public function DDLSAStar()
		{
			__iterEdge = new IteratorFromFaceToInnerEdges();
		}
		
		public function dispose():void
		{
			_mesh = null;
			
			 __closedFaces = null;
			__sortedOpenedFaces = null;
			__openedFaces = null;
			__entryEdges = null;
			__entryX = null;
			__entryY = null;
			__scoreF = null;
			__scoreG = null;
			__scoreH = null;
			__predecessor = null;
		}
		
		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
			_radiusSquared = _radius*_radius;
			_diameter = _radius*2;
			_diameterSquared = _diameter*_diameter;
		}

		public function set mesh(value:DDLSMesh):void
		{
			_mesh = value;
		}
		
		private var __fromFace:DDLSFace;
		private var __toFace:DDLSFace;
		private var __curFace:DDLSFace;
		public function findPath(fromX:Number, fromY:Number, toX:Number, toY:Number
								, resultListFaces:Vector.<DDLSFace>
								, resultListEdges:Vector.<DDLSEdge>):void
		{
			//trace("findPath");
			__closedFaces = new Dictionary();
			__sortedOpenedFaces = new Vector.<DDLSFace>();
			__openedFaces = new Dictionary();
			__entryEdges = new Dictionary();
			__entryX = new Dictionary();
			__entryY = new Dictionary();
			__scoreF = new Dictionary();
			__scoreG = new Dictionary();
			__scoreH = new Dictionary();
			__predecessor = new Dictionary();
			
			var loc:Object;
			var locEdge:DDLSEdge;
			var locVertex:DDLSVertex;
			var distance:Number;
			var p1:DDLSPoint2D;
			var p2:DDLSPoint2D;
			var p3:DDLSPoint2D;
			//
			loc = DDLSGeom2D.locatePosition(fromX, fromY, _mesh);
			if ( (locVertex = loc as DDLSVertex) )
			{
				// vertex are always in constraint, so we abort
				return;
			}
			else if ( (locEdge = loc as DDLSEdge) )
			{
				// if the vertex lies on a constrained edge, we abort
				if (locEdge.isConstrained)
					return;
				
				__fromFace = locEdge.leftFace;
			}
			else
			{
				__fromFace = loc as DDLSFace;
			}
			//
			loc = DDLSGeom2D.locatePosition(toX, toY, _mesh);
			if ( (locVertex = loc as DDLSVertex) )
				__toFace = locVertex.edge.leftFace;
			else if ( (locEdge = loc as DDLSEdge) )
				__toFace = locEdge.leftFace;
			else
				__toFace = loc as DDLSFace;
			
			/*__fromFace.colorDebug = 0xFF0000;
			__toFace.colorDebug = 0xFF0000;
			trace( "from face:", __fromFace );
			trace( "to face:", __toFace );*/
			
			__sortedOpenedFaces.push(__fromFace);
			__entryEdges[__fromFace] = null;
			__entryX[__fromFace] = fromX;
			__entryY[__fromFace] = fromY;
			__scoreG[__fromFace] = 0;
			__scoreH[__fromFace] = Math.sqrt((toX - fromX)*(toX - fromX) + (toY - fromY)*(toY - fromY));
			__scoreF[__fromFace] = __scoreH[__fromFace] + __scoreG[__fromFace];
			
			var innerEdge:DDLSEdge;
			var neighbourFace:DDLSFace;
			var f:Number;
			var g:Number;
			var h:Number;
			var fromPoint:DDLSPoint2D = new DDLSPoint2D();
			var entryPoint:DDLSPoint2D = new DDLSPoint2D();
			var distancePoint:DDLSPoint2D = new DDLSPoint2D();
			var fillDatas:Boolean;
			while (true)
			{
				// no path found
				if (__sortedOpenedFaces.length == 0)
				{
					trace("DDLSAStar no path found");
					__curFace = null;
					break;
				}
				
				// we reached the target face
				__curFace = __sortedOpenedFaces.pop();
				if (__curFace == __toFace)
				{
					break;
				}
				
				// we continue the search
				__iterEdge.fromFace = __curFace;
				while ( innerEdge = __iterEdge.next() )
				{
					if (innerEdge.isConstrained)
						continue;
					
					neighbourFace = innerEdge.rightFace;
					if (! __closedFaces[neighbourFace] )
					{
						if ( __curFace != __fromFace && _radius > 0 && ! isWalkableByRadius(__entryEdges[__curFace], __curFace, innerEdge))
						{
//							trace("- NOT WALKABLE -");
//							trace( "from", DDLSEdge(__entryEdges[__curFace]).originVertex.id, DDLSEdge(__entryEdges[__curFace]).destinationVertex.id );
//							trace( "to", innerEdge.originVertex.id, innerEdge.destinationVertex.id );
//							trace("----------------");
							continue;
						}
						
						fromPoint.x = __entryX[__curFace];
						fromPoint.y = __entryY[__curFace];
						entryPoint.x = (innerEdge.originVertex.pos.x + innerEdge.destinationVertex.pos.x) /2;
						entryPoint.y = (innerEdge.originVertex.pos.y + innerEdge.destinationVertex.pos.y) /2;
						distancePoint.x = entryPoint.x - toX;
						distancePoint.y = entryPoint.y - toY;
						h = distancePoint.length;
						distancePoint.x = fromPoint.x - entryPoint.x;
						distancePoint.y = fromPoint.y - entryPoint.y;
						g = __scoreG[__curFace] + distancePoint.length;
						f = h + g;
						fillDatas = false;
						if (! __openedFaces[neighbourFace]  )
						{
							__sortedOpenedFaces.push(neighbourFace);
							__openedFaces[neighbourFace] = true;
							fillDatas = true;
						}
						else if ( __scoreF[neighbourFace] > f )
						{
							fillDatas = true;
						}
						if (fillDatas)
						{
							__entryEdges[neighbourFace] = innerEdge;
							__entryX[neighbourFace] = entryPoint.x;
							__entryY[neighbourFace] = entryPoint.y;
							__scoreF[neighbourFace] = f;
							__scoreG[neighbourFace] = g;
							__scoreH[neighbourFace] = h;
							__predecessor[neighbourFace] = __curFace;
						}
					}
				}
				//
				__openedFaces[__curFace] = null;
				__closedFaces[__curFace] = true;
				__sortedOpenedFaces.sort(sortingFaces);
			}
			
			// if we didn't find a path
			if (! __curFace)
				return;
			
			// else we build the path
			resultListFaces.push(__curFace);
			//__curFace.colorDebug = 0x0000FF;
			while (__curFace != __fromFace)
			{
				resultListEdges.unshift(__entryEdges[__curFace]);
				//__entryEdges[__curFace].colorDebug = 0xFFFF00;
				//__entryEdges[__curFace].oppositeEdge.colorDebug = 0xFFFF00;
				__curFace = __predecessor[__curFace];
				//__curFace.colorDebug = 0x0000FF;
				resultListFaces.unshift(__curFace);
			}
		}
		
		// faces with low distance value are at the end of the array
		private function sortingFaces(a:DDLSFace, b:DDLSFace):Number
		{
			if (__scoreF[a] == __scoreF[b])
				return 0;
			else if (__scoreF[a] < __scoreF[b])
				return 1;
			else
				return -1;
		}
		
		private function isWalkableByRadius(fromEdge:DDLSEdge, throughFace:DDLSFace, toEdge:DDLSEdge):Boolean
		{
			var vA:DDLSVertex; // the vertex on fromEdge not on toEdge
			var vB:DDLSVertex; // the vertex on toEdge not on fromEdge
			var vC:DDLSVertex; // the common vertex of the 2 edges (pivot)
			
			// we identify the points
			if ( fromEdge.originVertex == toEdge.originVertex )
			{
				vA = fromEdge.destinationVertex;
				vB = toEdge.destinationVertex;
				vC = fromEdge.originVertex;
			}
			else if (fromEdge.destinationVertex == toEdge.destinationVertex)
			{
				vA = fromEdge.originVertex;
				vB = toEdge.originVertex;
				vC = fromEdge.destinationVertex;
			}
			else if (fromEdge.originVertex == toEdge.destinationVertex)
			{
				vA = fromEdge.destinationVertex;
				vB = toEdge.originVertex;
				vC = fromEdge.originVertex;
			}
			else if (fromEdge.destinationVertex == toEdge.originVertex)
			{
				vA = fromEdge.originVertex;
				vB = toEdge.destinationVertex;
				vC = fromEdge.destinationVertex;
			}
			
			var dot:Number;
			var result:Boolean;
			var distSquared:Number;
			
			// if we have a right or obtuse angle on CAB
			dot = (vC.pos.x - vA.pos.x)*(vB.pos.x - vA.pos.x) + (vC.pos.y - vA.pos.y)*(vB.pos.y - vA.pos.y);
			if (dot <= 0)
			{
				// we compare length of AC with radius
				distSquared = (vC.pos.x - vA.pos.x)*(vC.pos.x - vA.pos.x) + (vC.pos.y - vA.pos.y)*(vC.pos.y - vA.pos.y);
				if (distSquared >= _diameterSquared)
					return true;
				else
					return false;
			}
			
			// if we have a right or obtuse angle on CBA
			dot = (vC.pos.x - vB.pos.x)*(vA.pos.x - vB.pos.x) + (vC.pos.y - vB.pos.y)*(vA.pos.y - vB.pos.y);
			if (dot <= 0)
			{
				// we compare length of BC with radius
				distSquared = (vC.pos.x - vB.pos.x)*(vC.pos.x - vB.pos.x) + (vC.pos.y - vB.pos.y)*(vC.pos.y - vB.pos.y);
				if (distSquared >= _diameterSquared)
					return true;
				else
					return false;
			}
			
			// we identify the adjacent edge (facing pivot vertex)
			var adjEdge:DDLSEdge;
			if (throughFace.edge != fromEdge && throughFace.edge.oppositeEdge != fromEdge
				&& throughFace.edge != toEdge && throughFace.edge.oppositeEdge != toEdge)
				adjEdge = throughFace.edge;
			else if (throughFace.edge.nextLeftEdge != fromEdge && throughFace.edge.nextLeftEdge.oppositeEdge != fromEdge
					&& throughFace.edge.nextLeftEdge != toEdge && throughFace.edge.nextLeftEdge.oppositeEdge != toEdge)
				adjEdge = throughFace.edge.nextLeftEdge;
			else
				adjEdge = throughFace.edge.prevLeftEdge;
			
			// if the adjacent edge is constrained, we check the distance of orthognaly projected
			if (adjEdge.isConstrained)
			{
				var proj:DDLSPoint2D = new DDLSPoint2D(vC.pos.x, vC.pos.y);
				DDLSGeom2D.projectOrthogonaly(proj, adjEdge);
				distSquared = (proj.x - vC.pos.x)*(proj.x - vC.pos.x) + (proj.y - vC.pos.y)*(proj.y - vC.pos.y);
				if (distSquared >= _diameterSquared)
					return true;
				else
					return false;
			}
			else // if the adjacent is not constrained
			{
				var distSquaredA:Number = (vC.pos.x - vA.pos.x)*(vC.pos.x - vA.pos.x) + (vC.pos.y - vA.pos.y)*(vC.pos.y - vA.pos.y);
				var distSquaredB:Number = (vC.pos.x - vB.pos.x)*(vC.pos.x - vB.pos.x) + (vC.pos.y - vB.pos.y)*(vC.pos.y - vB.pos.y);
				if (distSquaredA < _diameterSquared || distSquaredB < _diameterSquared)
				{
					return false;
				}
				else
				{
					var vFaceToCheck:Vector.<DDLSFace> = new Vector.<DDLSFace>();
					var vFaceIsFromEdge:Vector.<DDLSEdge> = new Vector.<DDLSEdge>();
					var facesDone:Dictionary = new Dictionary();
					vFaceIsFromEdge.push(adjEdge);
					if (adjEdge.leftFace == throughFace)
					{
						vFaceToCheck.push(adjEdge.rightFace);
						facesDone[adjEdge.rightFace] = true;
					}
					else
					{
						vFaceToCheck.push(adjEdge.leftFace);
						facesDone[adjEdge.leftFace] = true;
					}
					
					var currFace:DDLSFace;
					var faceFromEdge:DDLSEdge;
					var currEdgeA:DDLSEdge;
					var nextFaceA:DDLSFace;
					var currEdgeB:DDLSEdge;
					var nextFaceB:DDLSFace;
					while (vFaceToCheck.length > 0)
					{
						currFace = vFaceToCheck.shift();
						faceFromEdge = vFaceIsFromEdge.shift();
						
						// we identify the 2 edges to evaluate
						if (currFace.edge == faceFromEdge || currFace.edge == faceFromEdge.oppositeEdge)
						{
							currEdgeA = currFace.edge.nextLeftEdge;
							currEdgeB = currFace.edge.nextLeftEdge.nextLeftEdge;
						}
						else if (currFace.edge.nextLeftEdge == faceFromEdge || currFace.edge.nextLeftEdge == faceFromEdge.oppositeEdge)
						{
							currEdgeA = currFace.edge;
							currEdgeB = currFace.edge.nextLeftEdge.nextLeftEdge;
						}
						else
						{
							currEdgeA = currFace.edge;
							currEdgeB = currFace.edge.nextLeftEdge;
						}
						
						// we identify the faces related to the 2 edges
						if (currEdgeA.leftFace == currFace)
							nextFaceA = currEdgeA.rightFace;
						else
							nextFaceA = currEdgeA.leftFace;
						if (currEdgeB.leftFace == currFace)
							nextFaceB = currEdgeB.rightFace;
						else
							nextFaceB = currEdgeB.leftFace;
							
						// we check if the next face is not already in pipe
						// and if the edge A is close to pivot vertex
						if ( ! facesDone[nextFaceA] && DDLSGeom2D.distanceSquaredVertexToEdge(vC, currEdgeA) < _diameterSquared )
						{
							// if the edge is constrained
							if ( currEdgeA.isConstrained )
							{
								// so it is not walkable
								return false;
							}
							else
							{
								// if the edge is not constrained, we continue the search
								vFaceToCheck.push(nextFaceA);
								vFaceIsFromEdge.push(currEdgeA);
								facesDone[nextFaceA] = true;
							}
						}
						
						// we check if the next face is not already in pipe
						// and if the edge B is close to pivot vertex
						if ( ! facesDone[nextFaceB] && DDLSGeom2D.distanceSquaredVertexToEdge(vC, currEdgeB) < _diameterSquared )
						{
							// if the edge is constrained
							if ( currEdgeB.isConstrained )
							{
								// so it is not walkable
								return false;
							}
							else
							{
								// if the edge is not constrained, we continue the search
								vFaceToCheck.push(nextFaceB);
								vFaceIsFromEdge.push(currEdgeB);
								facesDone[nextFaceB] = true;
							}
						}
					}
					
					// if we didn't previously meet a constrained edge
					return true;
				}
			}
			
			return true;
		}
		
		
	}
}
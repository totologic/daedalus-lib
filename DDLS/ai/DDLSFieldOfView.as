package DDLS.ai
{
	import DDLS.data.DDLSConstants;
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSFace;
	import DDLS.data.math.DDLSGeom2D;
	import DDLS.data.DDLSMesh;
	import DDLS.data.DDLSVertex;
	import DDLS.data.math.DDLSPoint2D;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class DDLSFieldOfView
	{
		
		private var _fromEntity:DDLSEntityAI;
		private var _mesh:DDLSMesh;
		
		public var _debug:Sprite;
		
		public function DDLSFieldOfView()
		{
			
		}
		
		public function get fromEntity():DDLSEntityAI
		{
			return _fromEntity;
		}

		public function set fromEntity(value:DDLSEntityAI):void
		{
			_fromEntity = value;
		}

		public function set mesh(value:DDLSMesh):void
		{
			_mesh = value;
		}
		
		public function isInField(targetEntity:DDLSEntityAI):Boolean
		{
			if (!_mesh)
				throw new Error("Mesh missing");
			if (!_fromEntity)
					throw new Error("From entity missing");
			
			var posX:Number = _fromEntity.x;
			var posY:Number = _fromEntity.y;
			var directionNormX:Number = _fromEntity.dirNormX;
			var directionNormY:Number = _fromEntity.dirNormY;
			var radius:Number = _fromEntity.radiusFOV;
			var angle:Number = _fromEntity.angleFOV;
			
			var targetX:Number = targetEntity.x;
			var targetY:Number = targetEntity.y;
			var targetRadius:Number = targetEntity.radius
			
			var distSquared:Number = (posX-targetX)*(posX-targetX) + (posY-targetY)*(posY-targetY);
			
			// if target is completely outside field radius
			if ( distSquared >= (radius + targetRadius)*(radius + targetRadius) )
			{
				//trace("target is completely outside field radius");
				return false;
			}
			
			if (distSquared < targetRadius*targetRadius)
			{
				//trace("degenerate case if the field center is inside the target");
				return true;
			}
			
			var result:Vector.<Number>;
			var leftTargetX:Number;
			var leftTargetY:Number;
			var rightTargetX:Number;
			var rightTargetY:Number;
			var leftTargetInField:Boolean;
			var rightTargetInField:Boolean;
			
			// we consider the 2 cicrles intersections
			result = new Vector.<Number>();
			if ( DDLSGeom2D.intersections2Circles(posX, posY, radius, targetX, targetY, targetRadius, result) )
			{
				leftTargetX = result[0];
				leftTargetY = result[1];
				rightTargetX = result[2];
				rightTargetY = result[3];
			}
			
			var midX:Number = 0.5*(posX + targetX);
			var midY:Number = 0.5*(posY + targetY);
			if ( result.length == 0 || (midX - targetX)*(midX - targetX) + (midY - targetY)*(midY - targetY) < (midX - leftTargetX)*(midX - leftTargetX) + (midY - leftTargetY)*(midY - leftTargetY) )
			{
				// we consider the 2 tangents from field center to target
				result.splice(0, result.length);
				DDLSGeom2D.tangentsPointToCircle(posX, posY, targetX, targetY, targetRadius, result);
				leftTargetX = result[0];
				leftTargetY = result[1];
				rightTargetX = result[2];
				rightTargetY = result[3];
			}
			
			if (_debug)
			{
				_debug.graphics.lineStyle(1, 0x0000FF);
				_debug.graphics.drawCircle(leftTargetX, leftTargetY, 2);
				_debug.graphics.lineStyle(1, 0xFF0000);
				_debug.graphics.drawCircle(rightTargetX, rightTargetY, 2);
			}
			
			var dotProdMin:Number = Math.cos(_fromEntity.angleFOV/2);
			// we compare the dots for the left point
			var leftX:Number = leftTargetX - posX;
			var leftY:Number = leftTargetY - posY;
			var lengthLeft:Number = Math.sqrt( leftX*leftX + leftY*leftY );
			var dotLeft:Number = (leftX/lengthLeft)*directionNormX + (leftY/lengthLeft)*directionNormY;
			// if the left point is in field
			if (dotLeft > dotProdMin)
			{
				//trace("the left point is in field");
				leftTargetInField = true;
			}
			else
			{
				leftTargetInField = false;
			}
			
			// we compare the dots for the right point
			var rightX:Number = rightTargetX - posX;
			var rightY:Number = rightTargetY - posY;
			var lengthRight:Number = Math.sqrt( rightX*rightX + rightY*rightY );
			var dotRight:Number = (rightX/lengthRight)*directionNormX + (rightY/lengthRight)*directionNormY;
			// if the right point is in field
			if (dotRight > dotProdMin)
			{
				//trace("the right point is in field");
				rightTargetInField = true;
			}
			else
			{
				rightTargetInField = false;
			}
			
			// if the left and right points are outside field
			if (!leftTargetInField && !rightTargetInField)
			{
				// we must check if the Left/right points are on 2 different sides
				if ( DDLSGeom2D.getDirection(posX, posY, posX+directionNormX, posY+directionNormY, leftTargetX, leftTargetY) == 1
					&& DDLSGeom2D.getDirection(posX, posY, posX+directionNormX, posY+directionNormY, rightTargetX, rightTargetY) == -1 )
				{
					//trace("the Left/right points are on 2 different sides");
					
				}
				else
				{
					// we abort : target is not in field
					return false;
				}
			}
			
			// we init the window
			if (!leftTargetInField || !rightTargetInField)
			{
				var p:DDLSPoint2D = new DDLSPoint2D();
				var dirAngle:Number;
				dirAngle = Math.atan2(directionNormY, directionNormX);
				if ( !leftTargetInField )
				{
					var leftFieldX:Number = Math.cos(dirAngle - angle/2);
					var leftFieldY:Number = Math.sin(dirAngle - angle/2);
					DDLSGeom2D.intersections2segments(posX, posY, posX+leftFieldX, posY+leftFieldY
													, leftTargetX, leftTargetY, rightTargetX, rightTargetY
													, p, null, true);
					if (_debug)
					{
						_debug.graphics.lineStyle(1, 0x0000FF);
						_debug.graphics.drawCircle(p.x, p.y, 2);
					}
					leftTargetX = p.x;
					leftTargetY = p.y;
				}
				if ( !rightTargetInField )
				{
					var rightFieldX:Number = Math.cos(dirAngle + angle/2);
					var rightFieldY:Number = Math.sin(dirAngle + angle/2);
					DDLSGeom2D.intersections2segments(posX, posY, posX+rightFieldX, posY+rightFieldY
													, leftTargetX, leftTargetY, rightTargetX, rightTargetY
													, p, null, true);
					if (_debug)
					{
						_debug.graphics.lineStyle(1, 0xFF0000);
						_debug.graphics.drawCircle(p.x, p.y, 2);
					}
					rightTargetX = p.x;
					rightTargetY = p.y;
				}
			}
			
			if (_debug)
			{
				_debug.graphics.lineStyle(1, 0x000000);
				_debug.graphics.moveTo(posX, posY);
				_debug.graphics.lineTo(leftTargetX, leftTargetY);
				_debug.graphics.lineTo(rightTargetX, rightTargetY);
				_debug.graphics.lineTo(posX, posY);
			}
			// now we have a triangle called the window defined by: posX, posY, rightTargetX, rightTargetY, leftTargetX, leftTargetY
			
			// we set a dictionnary of faces done
			var facesDone:Dictionary = new Dictionary();
			// we set a dictionnary of edges done
			var edgesDone:Dictionary = new Dictionary();
			// we set the window wall
			var wall:Vector.<Number> = new Vector.<Number>();
			// we localize the field center
			var startObj:Object = DDLSGeom2D.locatePosition(posX, posY, _mesh);
			var startFace:DDLSFace;
			if ( startObj is DDLSFace )
				startFace = startObj as DDLSFace;
			else if ( startObj is DDLSEdge )
				startFace = (startObj as DDLSEdge).leftFace;
			else if ( startObj is DDLSVertex )
				startFace = (startObj as DDLSVertex).edge.leftFace;
			
			
			// we put the face where the field center is lying in open list
			var openFacesList:Vector.<DDLSFace> = new Vector.<DDLSFace>();
			var openFaces:Dictionary = new Dictionary();
			openFacesList.push(startFace);
			openFaces[startFace] = true;
			
			var currentFace:DDLSFace;
			var currentEdge:DDLSEdge;
			var s1:DDLSPoint2D;
			var s2:DDLSPoint2D;
			var p1:DDLSPoint2D = new DDLSPoint2D()
			var p2:DDLSPoint2D = new DDLSPoint2D();
			var params:Vector.<Number> = new Vector.<Number>();
			var param1:Number;
			var param2:Number;
			var i:int;
			var index1:int;
			var index2:int;
			var edges:Vector.<DDLSEdge> = new Vector.<DDLSEdge>();
			// we iterate as long as we have new open facess
			while ( openFacesList.length > 0 )
			{
				// we pop the 1st open face: current face
				currentFace = openFacesList.shift();
				openFaces[currentFace] = null;
				facesDone[currentFace] = true;
				
				// for each non-done edges from the current face
				currentEdge = currentFace.edge;
				if ( !edgesDone[currentEdge] && !edgesDone[currentEdge.oppositeEdge] )
				{
					edges.push(currentEdge);
					edgesDone[currentEdge] = true;
				}
				currentEdge = currentEdge.nextLeftEdge;
				if ( !edgesDone[currentEdge] && !edgesDone[currentEdge.oppositeEdge] )
				{
					edges.push(currentEdge);
					edgesDone[currentEdge] = true;
				}
				currentEdge = currentEdge.nextLeftEdge;
				if ( !edgesDone[currentEdge] && !edgesDone[currentEdge.oppositeEdge] )
				{
					edges.push(currentEdge);
					edgesDone[currentEdge] = true;
				}
				
				while (edges.length > 0)
				{
					currentEdge = edges.pop();
					
					// if the edge overlap (interects or lies inside) the window
					s1 = currentEdge.originVertex.pos;
					s2 = currentEdge.destinationVertex.pos;
					if ( DDLSGeom2D.clipSegmentByTriangle(s1.x, s1.y, s2.x, s2.y, posX, posY, rightTargetX, rightTargetY, leftTargetX, leftTargetY, p1, p2) )
					{
						// if the edge if constrained
						if ( currentEdge.isConstrained )
						{
							if (_debug)
							{
								_debug.graphics.lineStyle(6, 0xFFFF00);
								_debug.graphics.moveTo(p1.x, p1.y);
								_debug.graphics.lineTo(p2.x, p2.y);
							}
							
							// we project the constrained edge on the wall
							params.splice(0, params.length);
							DDLSGeom2D.intersections2segments(posX, posY, p1.x, p1.y, leftTargetX, leftTargetY,  rightTargetX, rightTargetY, null, params, true);
							DDLSGeom2D.intersections2segments(posX, posY, p2.x, p2.y, leftTargetX, leftTargetY,  rightTargetX, rightTargetY, null, params, true);
							param1 = params[1];
							param2 = params[3];
							if ( param2 < param1 )
							{
								param1 = param2;
								param2 = params[1];
							}
							/*if (_debug)
							{
								_debug.graphics.lineStyle(3, 0x00FFFF);
								_debug.graphics.moveTo(leftTargetX + param1*(rightTargetX-leftTargetX), leftTargetY + param1*(rightTargetY-leftTargetY));
								_debug.graphics.lineTo(leftTargetX + param2*(rightTargetX-leftTargetX), leftTargetY + param2*(rightTargetY-leftTargetY));
							}*/
							
							// we sum it to the window wall
							for (i=wall.length-1 ; i>=0 ; i--)
							{
								if ( param2 >= wall[i] )
									break;
							}
							index2 = i+1;
							if (index2 % 2 == 0)
								wall.splice(index2, 0, param2);
							
							for (i=0 ; i<wall.length ; i++)
							{
								if ( param1 <= wall[i] )
									break;
							}
							index1 = i;
							if (index1 % 2 == 0)
							{
								wall.splice(index1, 0, param1);
								index2++;
							}
							else
							{
								index1--;
							}
							
							wall.splice( index1+1, index2-index1-1);
							
							// if the window is totally covered, we stop and return false
							if ( wall.length == 2
								&& -DDLSConstants.EPSILON < wall[0] && wall[0] < DDLSConstants.EPSILON
								&& 1-DDLSConstants.EPSILON < wall[1] && wall[1] < 1+DDLSConstants.EPSILON )
							{
								return false;
							}
						}
						
						// if the adjacent face is neither in open list nor in faces done dictionnary
						currentFace = currentEdge.rightFace;
						if (!openFaces[currentFace] && !facesDone[currentFace])
						{
							// we add it in open list
							openFacesList.push(currentFace);
							openFaces[currentFace] = true;
						}
					}
				}
			}
			
			if (_debug)
			{
				_debug.graphics.lineStyle(3, 0x00FFFF);

				for (i=0 ; i<wall.length ; i+=2)
				{
					_debug.graphics.moveTo(leftTargetX + wall[i]*(rightTargetX-leftTargetX), leftTargetY + wall[i]*(rightTargetY-leftTargetY));
					_debug.graphics.lineTo(leftTargetX + wall[i+1]*(rightTargetX-leftTargetX), leftTargetY + wall[i+1]*(rightTargetY-leftTargetY));
				}
			}
			// if the window is totally covered, we stop and return false
			/*if ( wall.length == 2
				&& -QEConstants.EPSILON < wall[0] && wall[0] < QEConstants.EPSILON
				&& 1-QEConstants.EPSILON < wall[1] && wall[1] < 1+QEConstants.EPSILON )
			{
				return false;
			}
			trace(wall);*/
			
			return true;
		}

	}
}
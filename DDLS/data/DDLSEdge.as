package DDLS.data
{
	import flash.utils.Dictionary;

	public class DDLSEdge
	{
		
		private static var INC:int = 0;
		private var _id:int;
		
		// root datas
		private var _isReal:Boolean;
		private var _isConstrained:Boolean;
		private var _originVertex:DDLSVertex;
		private var _oppositeEdge:DDLSEdge;
		private var _nextLeftEdge:DDLSEdge;
		private var _leftFace:DDLSFace;
		
		private var _fromConstraintSegments:Vector.<DDLSConstraintSegment>;
		
		public var colorDebug:int = -1;
		
		public function DDLSEdge()
		{
			_id = INC;
			INC++;
			
			_fromConstraintSegments = new Vector.<DDLSConstraintSegment>();
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get isReal():Boolean
		{
			return _isReal;
		}
		
		public function get isConstrained():Boolean
		{
			return _isConstrained;
		}
		
		public function setDatas( originVertex:DDLSVertex
								, oppositeEdge:DDLSEdge
								, nextLeftEdge:DDLSEdge
								, leftFace:DDLSFace
								, isReal:Boolean=true
								, isConstrained:Boolean=false):void
		{
			_isConstrained = isConstrained;
			_isReal = isReal;
			_originVertex = originVertex;
			_oppositeEdge = oppositeEdge;
			_nextLeftEdge = nextLeftEdge;
			_leftFace = leftFace;
		}
		
		public function addFromConstraintSegment(segment:DDLSConstraintSegment):void
		{
			if ( _fromConstraintSegments.indexOf(segment) == -1 )
				_fromConstraintSegments.push(segment);
		}
		
		public function removeFromConstraintSegment(segment:DDLSConstraintSegment):void
		{
			var index:int = _fromConstraintSegments.indexOf(segment);
			if ( index != -1 )
				_fromConstraintSegments.splice(index, 1);
		}
		
		public function set originVertex(value:DDLSVertex):void
		{
			_originVertex = value;
		}
		
		public function set nextLeftEdge(value:DDLSEdge):void
		{
			_nextLeftEdge = value;
		}
		
		public function set leftFace(value:DDLSFace):void
		{
			_leftFace = value;
		}
		
		public function set isConstrained(value:Boolean):void
		{
			_isConstrained = value;
		}
		
		public function get fromConstraintSegments():Vector.<DDLSConstraintSegment>
		{
			return _fromConstraintSegments;
		}
		
		public function set fromConstraintSegments(value:Vector.<DDLSConstraintSegment>):void
		{
			_fromConstraintSegments = value;
		}
		
		public function dispose():void
		{
			_originVertex = null;
			_oppositeEdge = null;
			_nextLeftEdge = null;
			_leftFace = null;
			_fromConstraintSegments = null;
		}
		
		public function get originVertex()		:DDLSVertex	{	return _originVertex;											}
		public function get destinationVertex()	:DDLSVertex	{	return _oppositeEdge.originVertex;								}
		public function get oppositeEdge()		:DDLSEdge		{	return _oppositeEdge;											}
		public function get nextLeftEdge()		:DDLSEdge		{	return _nextLeftEdge;											}
		public function get prevLeftEdge()		:DDLSEdge		{	return _nextLeftEdge.nextLeftEdge;								}
		public function get nextRightEdge()		:DDLSEdge		{	return _oppositeEdge.nextLeftEdge.nextLeftEdge.oppositeEdge;	}
		public function get prevRightEdge()		:DDLSEdge		{	return _oppositeEdge.nextLeftEdge.oppositeEdge;					}
		public function get rotLeftEdge()		:DDLSEdge		{	return _nextLeftEdge.nextLeftEdge.oppositeEdge;					}
		public function get rotRightEdge()		:DDLSEdge		{	return _oppositeEdge.nextLeftEdge;								}
		public function get leftFace()			:DDLSFace		{	return _leftFace;												}
		public function get rightFace()			:DDLSFace		{	return _oppositeEdge.leftFace;									}
		
		
		public function toString():String
		{
			return "edge " + originVertex.id + " - " + destinationVertex.id;
		}
		
		
	}
}

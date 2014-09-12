package DDLS.data
{
	import DDLS.data.math.DDLSPoint2D;

	public class DDLSVertex
	{
		
		private static var INC:int = 0;
		private var _id:int;
		
		private var _pos:DDLSPoint2D;
		
		private var _isReal:Boolean;
		private var _edge:DDLSEdge;
		
		private var _fromConstraintSegments:Vector.<DDLSConstraintSegment>;
		
		public var colorDebug:int = - 1;
		
		public function DDLSVertex()
		{
			_id = INC;
			INC++;
			
			_pos = new DDLSPoint2D();
			
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
		
		public function get pos():DDLSPoint2D
		{
			return _pos;
		}
		
		public function get fromConstraintSegments():Vector.<DDLSConstraintSegment>
		{
			return _fromConstraintSegments;
		}
		
		public function set fromConstraintSegments(value:Vector.<DDLSConstraintSegment>):void
		{
			_fromConstraintSegments = value;
		}
		
		public function setDatas(edge:DDLSEdge, isReal:Boolean=true):void
		{
			_isReal = isReal;
			_edge = edge;
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
		
		public function dispose():void
		{
			_pos = null;
			_edge = null;
			_fromConstraintSegments = null;
		}
		
		public function get edge():DDLSEdge
		{
			return _edge;
		}
		
		public function set edge(value:DDLSEdge):void
		{
			_edge = value;
		}
		
		public function toString():String
		{
			return "ver_id " + _id;
		}
		
	}
}
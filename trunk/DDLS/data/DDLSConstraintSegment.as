package DDLS.data
{
	public class DDLSConstraintSegment
	{
		
		private static var INC:int = 0;
		private var _id:int;
		
		private var _edges:Vector.<DDLSEdge>;
		private var _fromShape:DDLSConstraintShape;
		
		public function DDLSConstraintSegment()
		{
			_id = INC;
			INC++;
			
			_edges = new Vector.<DDLSEdge>();
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get fromShape():DDLSConstraintShape
		{
			return _fromShape;
		}

		public function set fromShape(value:DDLSConstraintShape):void
		{
			_fromShape = value;
		}
		
		public function addEdge(edge:DDLSEdge):void
		{
			if ( _edges.indexOf(edge) == -1 &&  _edges.indexOf(edge.oppositeEdge) == -1 )
				_edges.push(edge);
		}
		
		public function removeEdge(edge:DDLSEdge):void
		{
			var index:int;
			index = _edges.indexOf(edge);
			if ( index == -1 )
				index = _edges.indexOf(edge.oppositeEdge);
			
			if ( index != -1 )
				_edges.splice(index, 1);
		}
		
		public function get edges():Vector.<DDLSEdge>
		{
			return _edges;
		}
		
		public function dispose():void
		{
			_edges = null;
			_fromShape = null;
		}
		
		public function toString():String
		{
			return "seg_id " + _id;
		}
		
	}
}
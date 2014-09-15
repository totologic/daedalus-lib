package DDLS.data.graph
{
	public class DDLSGraphEdge
	{
		
		private static var INC:int = 0;
		private var _id:int;
		
		private var _prev:DDLSGraphEdge;
		private var _next:DDLSGraphEdge;
		
		private var _rotPrevEdge:DDLSGraphEdge;
		private var _rotNextEdge:DDLSGraphEdge;
		private var _oppositeEdge:DDLSGraphEdge;
		private var _sourceNode:DDLSGraphNode;
		private var _destinationNode:DDLSGraphNode;
		
		private var _data:Object;
		
		public function DDLSGraphEdge()
		{
			_id = INC;
			INC++;
		}

		public function get id():int
		{
			return _id;
		}
		
		public function dispose():void
		{
			
		}
		
		public function get prev():DDLSGraphEdge
		{
			return _prev;
		}
		
		public function set prev(value:DDLSGraphEdge):void
		{
			_prev = value;
		}
		
		public function get next():DDLSGraphEdge
		{
			return _next;
		}
		
		public function set next(value:DDLSGraphEdge):void
		{
			_next = value;
		}
		
		public function get rotPrevEdge():DDLSGraphEdge
		{
			return _rotPrevEdge;
		}
		
		public function set rotPrevEdge(value:DDLSGraphEdge):void
		{
			_rotPrevEdge = value;
		}
		
		public function get rotNextEdge():DDLSGraphEdge
		{
			return _rotNextEdge;
		}
		
		public function set rotNextEdge(value:DDLSGraphEdge):void
		{
			_rotNextEdge = value;
		}
		
		public function get oppositeEdge():DDLSGraphEdge
		{
			return _oppositeEdge;
		}
		
		public function set oppositeEdge(value:DDLSGraphEdge):void
		{
			_oppositeEdge = value;
		}
		
		public function get sourceNode():DDLSGraphNode
		{
			return _sourceNode;
		}
		
		public function set sourceNode(value:DDLSGraphNode):void
		{
			_sourceNode = value;
		}
		
		public function get destinationNode():DDLSGraphNode
		{
			return _destinationNode;
		}
		
		public function set destinationNode(value:DDLSGraphNode):void
		{
			_destinationNode = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
	}
}
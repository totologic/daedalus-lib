package DDLS.data.graph
{
	import flash.utils.Dictionary;

	public class DDLSGraphNode
	{
		
		private static var INC:int = 0;
		private var _id:int;
		
		private var _prev:DDLSGraphNode;
		private var _next:DDLSGraphNode;
		
		private var _outgoingEdge:DDLSGraphEdge;
		private var _successorNodes:Dictionary;
		
		private var _data:Object;
		
		public function DDLSGraphNode()
		{
			_id = INC;
			INC++;
			
			_successorNodes = new Dictionary();
		}

		public function get id():int
		{
			return _id;
		}
		
		public function dispose():void
		{
			_prev = null;
			_next = null;
			_outgoingEdge = null;
			_successorNodes = null;
			_data = null;
		}
		
		public function get prev():DDLSGraphNode
		{
			return _prev;
		}
		
		public function set prev(value:DDLSGraphNode):void
		{
			_prev = value;
		}
		
		public function get next():DDLSGraphNode
		{
			return _next;
		}
		
		public function set next(value:DDLSGraphNode):void
		{
			_next = value;
		}
		
		public function get outgoingEdge():DDLSGraphEdge
		{
			return _outgoingEdge;
		}
		
		public function set outgoingEdge(value:DDLSGraphEdge):void
		{
			_outgoingEdge = value;
		}
		
		public function get successorNodes():Dictionary
		{
			return _successorNodes;
		}
		
		public function set successorNodes(value:Dictionary):void
		{
			_successorNodes = value;
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
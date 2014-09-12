package DDLS.iterators
{
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSVertex;

	public class IteratorFromVertexToOutgoingEdges
	{
		
		private var _fromVertex:DDLSVertex;
		private var _nextEdge:DDLSEdge;
		
		public var realEdgesOnly:Boolean = true;
		
		public function IteratorFromVertexToOutgoingEdges()
		{
			
		}
		
		public function set fromVertex( value:DDLSVertex ):void
		{
			_fromVertex = value;
			_nextEdge = _fromVertex.edge;
			while ( realEdgesOnly && ! _nextEdge.isReal )
			{
				_nextEdge = _nextEdge.rotLeftEdge;
			}
		}
		
		private var _resultEdge:DDLSEdge;
		public function next():DDLSEdge
		{
			if (_nextEdge)
			{
				_resultEdge = _nextEdge;
				do
				{
					_nextEdge = _nextEdge.rotLeftEdge;
					if ( _nextEdge == _fromVertex.edge )
					{
						_nextEdge = null;
						break;
					}
				}
				while ( realEdgesOnly && ! _nextEdge.isReal )
			}
			else
			{
				_resultEdge = null;
			}
			
			return _resultEdge;
		}
		
	}
}
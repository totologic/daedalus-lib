package DDLS.iterators
{
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSVertex;

	public class IteratorFromVertexToIncomingEdges
	{
		
		private var _fromVertex:DDLSVertex;
		private var _nextEdge:DDLSEdge;
		
		public function IteratorFromVertexToIncomingEdges()
		{
			
		}
		
		public function set fromVertex( value:DDLSVertex ):void
		{	
			_fromVertex = value;
			_nextEdge = _fromVertex.edge;
			while ( ! _nextEdge.isReal )
			{
				_nextEdge = _nextEdge.rotLeftEdge;
			}
		}
		
		private var _resultEdge:DDLSEdge;
		public function next():DDLSEdge
		{
			if (_nextEdge)
			{
				_resultEdge = _nextEdge.oppositeEdge;
				do
				{
					_nextEdge = _nextEdge.rotLeftEdge;
					if ( _nextEdge == _fromVertex.edge )
					{
						_nextEdge = null;
						break;
					}
				}
				while ( ! _nextEdge.isReal )
			}
			else
			{
				_resultEdge = null;
			}
			
			return _resultEdge;
		}
		
	}
}
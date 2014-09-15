package DDLS.iterators
{
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSFace;
	import DDLS.data.DDLSVertex;

	public class IteratorFromVertexToHoldingFaces
	{
		
		private var _fromVertex:DDLSVertex;
		private var _nextEdge:DDLSEdge;
		
		public function IteratorFromVertexToHoldingFaces()
		{
			
		}
		
		public function set fromVertex( value:DDLSVertex ):void
		{
			_fromVertex = value;
			_nextEdge = _fromVertex.edge;
		}
		
		
		private var _resultFace:DDLSFace;
		public function next():DDLSFace
		{
			if (_nextEdge)
			{
				do
				{
					_resultFace = _nextEdge.leftFace;
					_nextEdge = _nextEdge.rotLeftEdge;
					if ( _nextEdge == _fromVertex.edge )
					{
						_nextEdge = null;
						if (! _resultFace.isReal)
							_resultFace = null;
						break;
					}
				}
				while ( ! _resultFace.isReal )
			}
			else
			{
				_resultFace = null;
			}
			
			return _resultFace;
		}
		
	}
}
package DDLS.iterators
{
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSFace;

	public class IteratorFromFaceToInnerEdges
	{
		
		private var _fromFace:DDLSFace;
		private var _nextEdge:DDLSEdge;
		
		public function IteratorFromFaceToInnerEdges()
		{
			
		}
		
		public function set fromFace( value:DDLSFace ):void
		{
			_fromFace = value;
			_nextEdge = _fromFace.edge;
		}
		
		private var _resultEdge:DDLSEdge;
		public function next():DDLSEdge
		{
			if (_nextEdge)
			{
				_resultEdge = _nextEdge;
				_nextEdge = _nextEdge.nextLeftEdge;
				
				if ( _nextEdge == _fromFace.edge )
					_nextEdge = null;
			}
			else
			{
				_resultEdge = null;
			}
			
			return _resultEdge;
		}
		
		
	}
}
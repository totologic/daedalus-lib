package DDLS.iterators
{
	import DDLS.data.DDLSFace;
	import DDLS.data.DDLSMesh;
	import DDLS.data.DDLSVertex;

	public class IteratorFromMeshToVertices
	{
		
		private var _fromMesh:DDLSMesh;
		private var _currIndex:int;
		
		public function IteratorFromMeshToVertices()
		{
			
		}
		
		public function set fromMesh(value:DDLSMesh):void
		{
			_fromMesh = value;
			_currIndex = 0;
		}
		
		private var _resultVertex:DDLSVertex;
		public function next():DDLSVertex
		{
			do
			{
				if (_currIndex < _fromMesh.__vertices.length)
				{
					_resultVertex = _fromMesh.__vertices[_currIndex];
					_currIndex++;
				}
				else
				{
					_resultVertex = null;
					break;
				}
			}
			while (! _resultVertex.isReal)
			
			return _resultVertex;
		}
		
	}
}
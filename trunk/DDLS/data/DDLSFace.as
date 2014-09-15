package DDLS.data
{
	public class DDLSFace
	{
		
		private static var INC:int = 0;
		private var _id:int;
		
		private var _isReal:Boolean;
		private var _edge:DDLSEdge;
		
		public var colorDebug:int = -1;
		
		public function DDLSFace()
		{
			_id = INC;
			INC++;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get isReal():Boolean
		{
			return _isReal;
		}
		
		public function setDatas(edge:DDLSEdge, isReal:Boolean=true):void
		{
			_isReal = isReal;
			_edge = edge;
		}
		
		public function dispose():void
		{
			_edge = null;
		}
		
		public function get edge():DDLSEdge
		{
			return _edge;
		}
		
	}
}
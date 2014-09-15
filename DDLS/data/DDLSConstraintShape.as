package DDLS.data
{
	public class DDLSConstraintShape
	{
		
		private static var INC:int = 0;
		private var _id:int;
		
		private var _segments:Vector.<DDLSConstraintSegment>;
		
		public function DDLSConstraintShape()
		{
			_id = INC;
			INC++;
			
			_segments = new Vector.<DDLSConstraintSegment>();
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get segments():Vector.<DDLSConstraintSegment>
		{
			return _segments;
		}
		
		public function dispose():void
		{
			while ( _segments.length > 0 )
				_segments.pop().dispose();
			_segments = null;
		}

	}
}
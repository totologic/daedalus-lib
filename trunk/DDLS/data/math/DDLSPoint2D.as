package DDLS.data.math
{

	public class DDLSPoint2D
	{
		
		private var _x:Number;
		private var _y:Number;
		
		public function DDLSPoint2D(x:Number=0, y:Number=0)
		{
			_x = x;
			_y = y;
		}
		
		public function transform(matrix:DDLSMatrix2D):void
		{
			matrix.tranform(this);
		}
		
		public function set(x:Number, y:Number):void
		{
			_x = x;
			_y = y;
		}
		
		public function clone():DDLSPoint2D
		{
			return new DDLSPoint2D(_x, _y);
		}
		
		public function substract(p:DDLSPoint2D):void
		{
			_x -= p.x;
			_y -= p.y;
		}
		
		public function get length():Number
		{
			return Math.sqrt(_x*_x + _y*_y);
		}
		
		
		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function normalize():void
		{
			var norm:Number = length;
			x = x/norm;
			y = y/norm;
		}
		
		public function scale(s:Number):void
		{
			x = x*s;
			y = y*s;
		}

	}
}
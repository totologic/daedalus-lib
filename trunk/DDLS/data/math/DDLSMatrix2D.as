package DDLS.data.math
{

	public class DDLSMatrix2D
	{
	/*	
		DDLSPoint2D represents row vector in homogeneous coordinates:
		[x, y, 1]
		
		DDLSMatrix2D represents transform matrix in homogeneous coordinates:
		[a, b, 0]
		[c, d, 0]
		[e, f, 1]
	*/
		
		private var _a:Number;
		private var _b:Number;
		private var _c:Number;
		private var _d:Number;
		private var _e:Number;
		private var _f:Number;
		
		public function DDLSMatrix2D(a:Number=1, b:Number=0, c:Number=0, d:Number=1, e:Number=0, f:Number=0)
		{
			_a = a;
			_b = b;
			_c = c;
			_d = d;
			_e = e;
			_f = f;
		}

		public function identity():void
		{
			/*
			[1, 0, 0]
			[0, 1, 0]
			[0, 0, 1]
			*/
			
			_a = 1;
			_b = 0;
			_c = 0;
			_d = 1;
			_e = 0;
			_f = 0;
		}
		
		public function translate(tx:Number, ty:Number):void
		{
			/*
			[1,  0,  0]
			[0,  1,  0]
			[tx, ty, 1]
			
			*/
			_e = _e + tx;
			_f = _f + ty;
		}
		
		public function scale(sx:Number, sy:Number):void
		{
			/*
			[sx, 0, 0]
			[0, sy, 0]
			[0,  0, 1]
			*/
			_a = _a*sx;
			_b = _b*sy;
			_c = _c*sx;
			_d = _d*sy;
			_e = _e*sx;
			_f = _f*sy;
		}
		
		public function rotate(rad:Number):void
		{
			/*
						[ cos, sin, 0]
						[-sin, cos, 0]
						[   0,   0, 1]
			
			[a, b, 0]
			[c, d, 0]
			[e, f, 1]
			*/
			var cos:Number = Math.cos(rad);
			var sin:Number = Math.sin(rad);
			var a:Number = _a*cos + _b*-sin;
			var b:Number = _a*sin + _b*cos;
			var c:Number = _c*cos + _d*-sin;
			var d:Number = _c*sin + _d*cos;
			var e:Number = _e*cos + _f*-sin;
			var f:Number = _e*sin + _f*cos;
			_a = a;
			_b = b
			_c = c;
			_d = d;
			_e = e;
			_f = f;
		}
		
		public function clone():DDLSMatrix2D
		{
			return new DDLSMatrix2D(_a, _b, _c, _d, _e, _f);
		}
		
		public function tranform(point:DDLSPoint2D):void
		{
			/*
						[a, b, 0]
						[c, d, 0]
						[e, f, 1]
			[x, y, 1]
			*/
			var x:Number = _a*point.x + _c*point.y + e;
			var y:Number = _b*point.x + _d*point.y + f;
			point.x = x;
			point.y = y;
		}
		
		public function transformX(x:Number, y:Number):Number
		{
			return _a*x + _c*y + e;
		}
		public function transformY(x:Number, y:Number):Number
		{
			return _b*x + _d*y + f;
		}
		
		public function concat(matrix:DDLSMatrix2D):void
		{
			var a:Number = _a*matrix.a + _b*matrix.c;
			var b:Number = _a*matrix.b + _b*matrix.d;
			var c:Number = _c*matrix.a + _d*matrix.c;
			var d:Number = _c*matrix.b + _d*matrix.d;
			var e:Number = _e*matrix.a + _f*matrix.c + matrix.e;
			var f:Number = _e*matrix.b + _f*matrix.d + matrix.f;
			_a = a
			_b = b;
			_c = c;
			_d = d;
			_e = e;
			_f = f;
		}
		
		public function get a():Number
		{
			return _a;
		}
		
		public function set a(value:Number):void
		{
			_a = value;
		}
		
		public function get b():Number
		{
			return _b;
		}
		
		public function set b(value:Number):void
		{
			_b = value;
		}
		
		public function get c():Number
		{
			return _c;
		}
		
		public function set c(value:Number):void
		{
			_c = value;
		}
		
		public function get d():Number
		{
			return _d;
		}
		
		public function set d(value:Number):void
		{
			_d = value;
		}
		
		public function get e():Number
		{
			return _e;
		}
		
		public function set e(value:Number):void
		{
			_e = value;
		}
		
		public function get f():Number
		{
			return _f;
		}
		
		public function set f(value:Number):void
		{
			_f = value;
		}
		
	}
}
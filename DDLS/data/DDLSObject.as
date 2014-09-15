package DDLS.data
{
	import DDLS.data.math.DDLSMatrix2D;

	public class DDLSObject
	{
		
		private static var INC:int = 0;
		private var _id:int;
		
		private var _matrix:DDLSMatrix2D;
		private var _coordinates:Vector.<Number>;
		private var _constraintShape:DDLSConstraintShape;
		
		private var _pivotX:Number;
		private var _pivotY:Number;
		
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _rotation:Number;
		private var _x:Number;
		private var _y:Number;
		
		private var _hasChanged:Boolean;
		
		public function DDLSObject()
		{
			_id = INC;
			INC++;
			
			_pivotX = 0;
			_pivotY = 0;
			
			_matrix = new DDLSMatrix2D();
			_scaleX = 1;
			_scaleY = 1;
			_rotation = 0;
			_x = 0;
			_y = 0;
			
			_coordinates = new Vector.<Number>();
			
			_hasChanged = false;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function dispose():void
		{
			_matrix = null;
			_coordinates = null;
			_constraintShape = null;
		}
		
		public function updateValuesFromMatrix():void
		{
			
		}
		
		public function updateMatrixFromValues():void
		{
			_matrix.identity();
			_matrix.translate(-_pivotX, -_pivotY);
			_matrix.scale(_scaleX, _scaleY);
			_matrix.rotate(_rotation);
			_matrix.translate(_x, _y);
		}
		
		public function get pivotX():Number
		{
			return _pivotX;
		}
		
		public function set pivotX(value:Number):void
		{
			_pivotX = value;
			_hasChanged = true;
		}
		
		public function get pivotY():Number
		{
			return _pivotY;
		}
		
		public function set pivotY(value:Number):void
		{
			_pivotY = value;
			_hasChanged = true;
		}
		
		public function get scaleX():Number
		{
			return _scaleX;
		}

		public function set scaleX(value:Number):void
		{
			if (_scaleX != value)
			{
				_scaleX = value;
				_hasChanged = true;
			}
		}

		public function get scaleY():Number
		{
			return _scaleY;
		}

		public function set scaleY(value:Number):void
		{
			if (_scaleY != value)
			{
				_scaleY = value;
				_hasChanged = true;
			}
		}

		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(value:Number):void
		{
			if (_rotation != value)
			{
				_rotation = value;
				_hasChanged = true;
			}
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			if (_x != value)
			{
				_x = value;
				_hasChanged = true;
			}
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			if (_y != value)
			{
				_y = value;
				_hasChanged = true;
			}
		}

		public function get matrix():DDLSMatrix2D
		{
			return _matrix;
		}

		public function set matrix(value:DDLSMatrix2D):void
		{
			_matrix = value;
			_hasChanged = true;
		}

		public function get coordinates():Vector.<Number>
		{
			return _coordinates;
		}

		public function set coordinates(value:Vector.<Number>):void
		{
			_coordinates = value;
			_hasChanged = true;
		}

		public function get constraintShape():DDLSConstraintShape
		{
			return _constraintShape;
		}

		public function set constraintShape(value:DDLSConstraintShape):void
		{
			_constraintShape = value;
			_hasChanged = true;
		}

		public function get hasChanged():Boolean
		{
			return _hasChanged;
		}

		public function set hasChanged(value:Boolean):void
		{
			_hasChanged = value;
		}
		
		public function get edges():Vector.<DDLSEdge>
		{
			var res:Vector.<DDLSEdge> = new Vector.<DDLSEdge>();
			
			for (var i:int=0 ; i< _constraintShape.segments.length ; i++)
			{
				for (var j:int=0 ; j<_constraintShape.segments[i].edges.length ; j++)
					res.push(_constraintShape.segments[i].edges[j]);
			}
			
			return res;
		}

	}
}
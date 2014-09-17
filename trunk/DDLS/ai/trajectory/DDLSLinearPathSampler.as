package DDLS.ai.trajectory
{
	import DDLS.ai.DDLSEntityAI;
	
	public class DDLSLinearPathSampler
	{
		private var _entity:DDLSEntityAI;
		private var _currentX:Number;
		private var _currentY:Number;
		private var _hasPrev:Boolean;
		private var _hasNext:Boolean;
		
		private var _samplingDistance:Number = 1;
		private var _samplingDistanceSquared:Number = 1;
		private var _path:Vector.<Number>;
		private var _iPrev:int;
		private var _iNext:int;
		
		private var _preComputed:Boolean;
		private var _count:int;
		private var _preCompX:Vector.<Number>;
		private var _preCompY:Vector.<Number>;
		
		public function DDLSLinearPathSampler()
		{
			_preCompX = new Vector.<Number>();
			_preCompY = new Vector.<Number>();
		}
		
		public function dispose():void
		{
			_entity = null;
			_path = null;
			_preCompX = null;
			_preCompY = null;
		}

		public function get entity():DDLSEntityAI
		{
			return _entity;
		}
		
		public function set entity(value:DDLSEntityAI):void
		{
			_entity = value;
		}
		
		public function get x():Number
		{
			return _currentX;
		}
		
		public function get y():Number
		{
			return _currentY;
		}
		
		public function get hasPrev():Boolean
		{
			return _hasPrev;
		}
		
		public function get hasNext():Boolean
		{
			return _hasNext;
		}
		
		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count = value;
			if (_count < 0)
				_count = 0;
			if (_count > countMax-1)
				_count = countMax-1;
			
			if (_count == 0)
				_hasPrev = false;
			else
				_hasPrev = true;
			if (_count == countMax-1)
				_hasNext = false;
			else
				_hasNext = true;
			
			_currentX = _preCompX[_count];
			_currentY = _preCompY[_count];
			updateEntity();
		}
		
		public function get countMax():int
		{
			return _preCompX.length-1;
		}
		
		public function get samplingDistance():Number
		{
			return _samplingDistance;
		}
		
		public function set samplingDistance(value:Number):void
		{
			_samplingDistance = value;
			_samplingDistanceSquared = _samplingDistance*_samplingDistance;
		}

		public function set path(value:Vector.<Number>):void
		{
			_path = value;
			_preComputed = false;
			reset();
		}
		
		public function reset():void
		{
			if (_path.length > 0)
			{
				_currentX = _path[0];
				_currentY = _path[1];
				_iPrev = 0;
				_iNext = 2;
				_hasPrev = false;
				_hasNext = true;
				_count = 0;
				updateEntity();
			}
			else
			{
				_hasPrev = false;
				_hasNext = false;
				_count = 0;
			}
		}
		
		public function preCompute():void
		{
			_preCompX.splice(0, _preCompX.length);
			_preCompY.splice(0, _preCompY.length);
			_count = 0;
			
			_preCompX.push(_currentX);
			_preCompY.push(_currentY);
			_preComputed = false;
			while (next())
			{
				_preCompX.push(_currentX);
				_preCompY.push(_currentY);
			}
			reset();
			_preComputed = true;
		}
		
		public function prev():Boolean
		{
			if (! _hasPrev)
				return false;
			_hasNext = true;
			
			
			if ( _preComputed )
			{
				_count--;
				if (_count == 0)
					_hasPrev = false;
				_currentX = _preCompX[_count];
				_currentY = _preCompY[_count];
				updateEntity();
				return true;
			}
			
			
			var remainingDist:Number;
			var dist:Number;
			
			remainingDist = _samplingDistance;
			while ( true )
			{
				dist = Math.sqrt((_currentX - _path[_iPrev])*(_currentX - _path[_iPrev]) + (_currentY - _path[_iPrev+1])*(_currentY - _path[_iPrev+1]));
				if ( dist < remainingDist )
				{
					remainingDist -= dist;
					_iPrev -= 2;
					_iNext -= 2;
					
					if (_iNext == 0)
						break;
				}
				else
					break;
			}
			
			if (_iNext == 0)
			{
				_currentX = _path[0];
				_currentY = _path[1];
				_hasPrev = false;
				_iNext = 2;
				_iPrev = 0;
				updateEntity();
				return true;
			}
			else
			{
				_currentX = _currentX + (_path[_iPrev] - _currentX) * remainingDist / dist;
				_currentY = _currentY + (_path[_iPrev+1] - _currentY) * remainingDist / dist;
				updateEntity();
				return true;
			}
		}
		
		public function next():Boolean
		{
			if (! _hasNext)
				return false;
			_hasPrev = true;
			
			
			if ( _preComputed )
			{
				_count++;
				if (_count == _preCompX.length-1)
					_hasNext = false;
				_currentX = _preCompX[_count];
				_currentY = _preCompY[_count];
				updateEntity();
				return true;
			}
			
			
			var remainingDist:Number;
			var dist:Number;
			
			remainingDist = _samplingDistance;
			while ( true )
			{
				dist = Math.sqrt((_currentX - _path[_iNext])*(_currentX - _path[_iNext]) + (_currentY - _path[_iNext+1])*(_currentY - _path[_iNext+1]));
				if ( dist < remainingDist )
				{
					remainingDist -= dist;
					_currentX = _path[_iNext];
					_currentY = _path[_iNext+1];
					_iPrev += 2;
					_iNext += 2;
					
					if (_iNext == _path.length)
						break;
				}
				else
					break;
			}
			
			if (_iNext == _path.length)
			{
				_currentX = _path[_iPrev];
				_currentY = _path[_iPrev+1];
				_hasNext = false;
				_iNext = _path.length-2;
				_iPrev = _iNext-2;
				updateEntity();
				return true;
			}
			else
			{
				_currentX = _currentX + (_path[_iNext] - _currentX) * remainingDist / dist;
				_currentY = _currentY + (_path[_iNext+1] - _currentY) * remainingDist / dist;
				updateEntity();
				return true;
			}
		}
		
		private function updateEntity():void
		{
			if (!_entity)
				return;
			
			_entity.x = _currentX;
			_entity.y = _currentY;
		}
		
	}
}
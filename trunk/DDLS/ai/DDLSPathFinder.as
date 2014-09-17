package DDLS.ai
{
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSFace;
	import DDLS.data.DDLSMesh;
	import DDLS.data.math.DDLSGeom2D;

	public class DDLSPathFinder
	{
		
		private var _mesh:DDLSMesh;
		private var _astar:DDLSAStar;
		private var _funnel:DDLSFunnel;
		private var _entity:DDLSEntityAI;
		private var _radius:Number;
		
		
		private var __listFaces:Vector.<DDLSFace>;
		private var __listEdges:Vector.<DDLSEdge>;
		
		public function DDLSPathFinder()
		{
			_astar = new DDLSAStar();
			_funnel = new DDLSFunnel();
			
			__listFaces = new Vector.<DDLSFace>();
			__listEdges = new Vector.<DDLSEdge>();
		}
		
		public function dispose():void
		{
			_mesh = null;
			_astar.dispose();
			_astar = null;
			_funnel.dispose();
			_funnel = null;
			__listEdges = null;
			__listFaces = null;
		}
		
		public function get entity():DDLSEntityAI
		{
			return _entity;
		}

		public function set entity(value:DDLSEntityAI):void
		{
			_entity = value;
		}

		public function get mesh():DDLSMesh
		{
			return _mesh;
		}

		public function set mesh(value:DDLSMesh):void
		{
			_mesh = value;
			_astar.mesh = _mesh;
		}
		
		public function findPath(toX:Number, toY:Number, resultPath:Vector.<Number>):void
		{
			resultPath.splice(0, resultPath.length);
			
			if (!_mesh)
				throw new Error("Mesh missing");
			if (!_entity)
				throw new Error("Entity missing");
			
			if (DDLSGeom2D.isCircleIntersectingAnyConstraint(toX, toY, _entity.radius, _mesh))
			{
				return;
			}
			
			_astar.radius = _entity.radius;
			_funnel.radius = _entity.radius;
			
			__listFaces.splice(0, __listFaces.length);
			__listEdges.splice(0, __listEdges.length);
			_astar.findPath(_entity.x, _entity.y, toX, toY, __listFaces, __listEdges);
			if (__listFaces.length == 0)
			{
				trace("DDLSPathFinder __listFaces.length == 0");
				return;
			}
			_funnel.findPath(_entity.x, _entity.y, toX, toY, __listFaces, __listEdges, resultPath);
		}

	}
}
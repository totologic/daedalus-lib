package
{
	import DDLS.ai.DDLSEntityAI;
	import DDLS.ai.DDLSPathFinder;
	import DDLS.ai.trajectory.DDLSLinearPathSampler;
	import DDLS.data.DDLSMesh;
	import DDLS.data.DDLSObject;
	import DDLS.data.math.DDLSPoint2D;
	import DDLS.data.math.DDLSRandGenerator;
	import DDLS.factories.DDLSRectMeshFactory;
	import DDLS.view.DDLSSimpleView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="600", height="600")]
	public class DemoPathfinding extends Sprite
	{
		
		private var _mesh:DDLSMesh;
		private var _view:DDLSSimpleView;
		
		private var _entityAI:DDLSEntityAI;
		private var _pathfinder:DDLSPathFinder;
		private var _path:Vector.<Number>;
		private var _pathSampler:DDLSLinearPathSampler;
		
		public function DemoPathfinding()
		{
			// build a rectangular 2 polygons mesh of 600x600
			_mesh = DDLSRectMeshFactory.buildRectangle(600, 600);
			
			
			// create a viewport
			_view = new DDLSSimpleView();
			addChild(_view.surface);
			
			
			// pseudo random generator
			var randGen:DDLSRandGenerator
			randGen = new DDLSRandGenerator();
			randGen.seed = 7259; // put a 4 digits number here
			
			// populate mesh with many square objects
			var object:DDLSObject;
			var shapeCoords:Vector.<Number>;
			for (var i:int=0 ; i<50 ; i++)
			{
				object = new DDLSObject();
				shapeCoords = new Vector.<Number>();
				shapeCoords.push(-1, -1, 1, -1);
				shapeCoords.push(1, -1, 1, 1);
				shapeCoords.push(1, 1, -1, 1);
				shapeCoords.push(-1, 1, -1, -1);
				object.coordinates = shapeCoords;
				randGen.rangeMin = 10;
				randGen.rangeMax = 40;
				object.scaleX = randGen.next();
				object.scaleY = randGen.next();
				randGen.rangeMin = 0;
				randGen.rangeMax = 1000;
				object.rotation = (randGen.next()/1000) * Math.PI / 2;
				randGen.rangeMin = 50;
				randGen.rangeMax = 600;
				object.x = randGen.next();
				object.y = randGen.next();
				_mesh.insertObject(object);
			}
			
			
			// show result mesh on screen
			_view.drawMesh(_mesh);
			
			
			// we need an entity
			_entityAI = new DDLSEntityAI();
				// set radius as size for your entity
			_entityAI.radius = 10;
				// set a position
			_entityAI.x = 20; 
			_entityAI.y = 20;
			
			
			// show entity on screen
			_view.drawEntity(_entityAI);
			
			
			// now configure the pathfinder
			_pathfinder = new DDLSPathFinder();
			_pathfinder.entity = _entityAI; // set the entity
			_pathfinder.mesh = _mesh; // set the mesh
			
			
			// we need a vector to store the path
			_path = new Vector.<Number>();
			
			
			// then configure the path sampler
			_pathSampler = new DDLSLinearPathSampler();
			_pathSampler.entity = _entityAI;
			_pathSampler.samplingDistance = 5;
			_pathSampler.path = _path;
			
			
			// CLICK !!
			stage.addEventListener(MouseEvent.CLICK, _onClick);
		}
		
		private function _onClick(event:MouseEvent):void
		{
			// find path !
			_pathfinder.findPath(stage.mouseX, stage.mouseY, _path);
			
			// show path on screen
			_view.drawPath(_path);
			
			// reset the path sampler to manage new generated path
			_pathSampler.reset();
			
			// animate !
			stage.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(event:Event):void
		{
			if (_pathSampler.hasNext)
			{
				// move entity
				_pathSampler.next();
				
				// show entty new position on screen
				_view.drawEntity(_entityAI);
			}
			else
			{
				// animation is over
				stage.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
		}
		
	}
}
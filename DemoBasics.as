package
{
	import DDLS.data.DDLSConstraintSegment;
	import DDLS.data.DDLSConstraintShape;
	import DDLS.data.DDLSMesh;
	import DDLS.data.DDLSObject;
	import DDLS.data.DDLSVertex;
	import DDLS.factories.DDLSRectMeshFactory;
	import DDLS.view.DDLSSimpleView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="600", height="400")]
	public class DemoBasics extends Sprite
	{
		
		private var _mesh:DDLSMesh;
		private var _view:DDLSSimpleView;
		private var _object:DDLSObject;
		
		public function DemoBasics()
		{
			// build a rectangular 2 polygons mesh of 600x400
			_mesh = DDLSRectMeshFactory.buildRectangle(600, 400);
			
			
			// create a viewport
			_view = new DDLSSimpleView();
			addChild(_view.surface);
			
			
			// SINGLE VERTEX INSERTION / DELETION
				// insert a vertex in mesh at coordinates (550, 50)
			var vertex:DDLSVertex = _mesh.insertVertex(550, 50);
				// if you want to delete that vertex :
			//_mesh.deleteVertex(vertex);
			
			
			// SINGLE CONSTRAINT SEGMENT INSERTION / DELETION
				// insert a segment in mesh with end points (70, 300) and (530, 320)
			var segment:DDLSConstraintSegment = _mesh.insertConstraintSegment(70, 300, 530, 320);
				// if you want to delete that edge
			//_mesh.deleteConstraintSegment(segment);
			
			
			// CONSTRAINT SHAPE INSERTION / DELETION
				// insert a shape in mesh (a crossed square)
			var shapeCoords:Vector.<Number> = new Vector.<Number>();
			shapeCoords.push(50, 50, 100, 50);   // 1st segment with end points (50, 50) and (100, 50)
			shapeCoords.push(100, 50, 100, 100); // 2nd segment with end points (100, 50) and (100, 100)
			shapeCoords.push(100, 100, 50, 100); // 3rd segment with end points (100, 100) and (50, 100)
			shapeCoords.push(50, 100, 50, 50);   // 4rd segment with end points (50, 100) and (50, 50)
			shapeCoords.push(20, 50, 130, 100);  // 5rd segment with end points (20, 50) and (130, 100)
			var shape:DDLSConstraintShape = _mesh.insertConstraintShape(shapeCoords);
				// if you want to delete that shape
			//_mesh.deleteConstraintShape(shape);
			
			
			// OBJECT INSERTION / TRANSFORMATION / DELETION
				// insert an object in mesh (a cross)
			var objectCoords:Vector.<Number> = new Vector.<Number>();
			objectCoords.push(-50, 0, 50, 0);
			objectCoords.push(0, -50, 0, 50);
			objectCoords.push(-30, -30, 30, 30);
			objectCoords.push(30, -30, -30, 30);
			_object = new DDLSObject();
			_object.coordinates = objectCoords;
			_mesh.insertObject(_object); // insert after coordinates are setted
				// you can transform objects with x, y, rotation, scaleX, scaleY, pivotX, pivotY
			_object.x = 400;
			_object.y = 200;
			_object.scaleX = 2;
			_object.scaleY = 2;
				// if you want to delete that object
			//_mesh.deleteObject(_object);
			
			addEventListener(Event.ENTER_FRAME, _onFrame);
		}
		
		private function _onFrame(event:Event):void
		{
			// objects can be transformed at any time
			_object.rotation += 0.05;
			
			_mesh.updateObjects(); // don't forget to update
			
			// render mesh
			_view.drawMesh(_mesh);
		}
		
	}
}
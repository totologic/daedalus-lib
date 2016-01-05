Instead of building constraints by exhaustively write set of coordinates, you can generate them by vectorization of black and white images.

### How to create an object from image ###

You can use the following static to create new `DDLSObject` instances from images:

`DDLSBitmapObjectFactory.buildFromBmpData(bmpData:BitmapData):DDLSObject`

example:

```
// build a rectangle mesh
var mesh:DDLSMesh = DDLSRectMeshFactory.buildRectangle(600, 400);

// we draw a black circle on Shape
var shape:Shape = new Shape();
shape.graphics.beginFill(0x000000);
shape.graphics.drawCircle(50, 50, 48);
shape.graphics.endFill();

// make a white BitmapData and then transfer the Shape on it
var bitmapData:BitmapData = new BitmapData(100, 100, false, 0xFFFFFF);
bitmapData.draw(shape);

// finally build the DDLSObject instance from the BitmapData
var object:DDLSObject = DDLSBitmapObjectFactory.buildFromBmpData(bitmapData);

// insert, tranform and update opbject
mesh.insertObject(object);
object.x = 100;
object.y = 100;
mesh.updateObjects();

// display
var view:DDLSSimpleView = new DDLSSimpleView();
addChild(view.surface);
view.drawMesh(mesh);
```

result:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page3/circle_bitmap.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page3/circle_bitmap.jpg)

Because the underlying implementation is inspired by the Potrace algorithm, you should remember to use images made from 2 colors only: black (0x000000) and white (0xFFFFFF). If your image contains other colors, a threshold will be applied and any color different from white will be considered as black.

As a recommendation, you should be careful about the size of the images you use. High resolution images can lead to a long time to process.

black and white 400x400 image example:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page3/supernull_nb.png](https://daedalus-lib.googlecode.com/svn/wiki/img/page3/supernull_nb.png)


result after triangulation:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page3/supernull_triangulated.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page3/supernull_triangulated.jpg)

[Next : Solve pathfinding requests](Pathfinding.md)
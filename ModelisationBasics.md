The first thing you will want is to create an empty mesh and populate with constraints.


### How to create a new mesh ###

Base class for meshes is `DDLSMesh`. Keep in mind this class because it manages almost all constraints insertion and deletion.

Although it is possible to instanciate directly a `DDLSMesh` object, it is not the more  convenient way to proceed. Think that Daedalus Lib implements triangulations through complex half-edge data structure, making them very hard to create from scratch for beginners.

Instead use the static:

`DDLSRectMeshFactory.buildRectangle(width:Number, height:Number):DDLSMesh`

example:

```
var mesh:DDLSMesh = DDLSRectMeshFactory.buildRectangle(600, 400);
```

The result is an instance of `DDLSMesh` as a 2 polygons rectangle of size 600x400:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page1/rect_mesh.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page1/rect_mesh.jpg)

Meshes implements coordinates space (x, y) with rules:
  * top-left corner defines (0, 0) coordinates
  * bottom-right corner defines (_width_, _height_) coordinates

You should consider this rectangle as defining an AABB for your environment.

### Constraints insertion ###

The most high-level class for constraint representation is `DDLSObject`. You should consider to use this class in most of cases because it is the most convenient to manipulate. Indeed `DDLSObject` supports basic 2D transformations:

  * `x`
  * `y`
  * `rotation`
  * `scaleX`
  * `scaleY`
  * `pivotX`
  * `pivotY`

After `DDLSObject` instanciation, the first thing you should do is to register its edges coordinates:

```
var object:DDLSObject = new DDLSObject;
// define it as a square shape:
var shapeCoords:Vector.<Number> = new Vector.<Number>();
shapeCoords.push(-50, -50, 50, -50); // 1st edge coordinates
shapeCoords.push(50, -50, 50, 50); // 2nd edge coordinates
shapeCoords.push(50, 50, -50, 50); // 3rd edge coordinates
shapeCoords.push(-50, 50, -50, -50); // 4th edge coordinates
object.coordinates = shapeCoords;
```

An edge must always be registered by coordinates of its 2 endpoints as a quadruplet `(x1, y1, x2, y2)`.

Literally, the coordinates vector must have the form:

`[e0_p1_x, e0_p1_y, e0_p2_x, e0_p2_y, e1_p1_x, e1_p1_y, e1_p2_x, e1_p2_y, ...]`

For convenience, you should consider that the registered coordinates are in object's local coordinates space.

You should not care about edges intersection or overlapping. Indeed Daedalus Lib manages properly and automatically vertices merging and sub-vertices insertions to keep a safe Delaunay triangulation.

Also, you must think a `DDLSObject` instance as an unbreakable set of edges and must be considered as a whole. It meets the concept of _rigid body_ in most of physic engines. So if at any time you feel the need to detach a subset edges from a `DDLSObject` instance, you should consider to create 2 `DDLSObject` instances instead.

Finally, `DDLSMesh` easily manages insertion:

```
mesh.insertObject(object);
```

Result:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page1/insert_square.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page1/insert_square.jpg)

Daedalus Lib manages AABB clipping and your inserted `DDLSObject` instance can safely be partly or completely outside of the mesh bounds.

Do insertion only when edges coordinates are fully registered. No more edges can be added after insertion.


### Constraints deletion ###

You can delete any previously inserted `DDLSObject` instance at any time. Just use the following:

```
mesh.deleteObject(object);
```

### Constraint transformation ###

Any transformation can be applied to your `DDLSObject` before insertion. You could translate, rotate or scale your object as it suits for your need.

example:
```
var mesh:DDLSMesh = DDLSRectMeshFactory.buildRectangle(600, 400);

var shapeCoords:Vector.<Number> = new Vector.<Number>();
shapeCoords.push(-50, -50, 50, -50); // 1st segment coordinates
shapeCoords.push(50, -50, 50, 50); // 2nd segment coordinates
shapeCoords.push(50, 50, -50, 50); // 3rd segment coordinates
shapeCoords.push(-50, 50, -50, -50); // 4th segment coordinates
object.coordinates = shapeCoords;

// slightly rotate the object and move it on the center
object.rotation = Math.PI / 8;
object.x = 300;
object.y = 200;

mesh.insertObject(object);
```

Result:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page1/transform_square.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page1/transform_square.jpg)

When transformations are set before insertion, they are automatically applied.

If you need to transform one or several instances of already inserted `DDLSObject`, you just need to force the transformations by calling:

```
mesh.updateObjects();
```

Notice that the `rotation` property is expressed in radians.

Also, remember that transformations are applied with a fixed order:
  1. scaling
  1. rotation
  1. translation

[Next : Display debug view for your triangulations](SimpleView.md)
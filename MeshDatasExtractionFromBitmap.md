Given a bitmap, Daedalus Lib can triangulate it and extract for you the whole mesh datas. Then these can easily be used in any third party library, as 3D or physics engine.

### What datas will I retrieve ? ###

While Daedalus Lib uses half-edge as internal data structure, it will return you a more common and easy to use face-vertex data structure, as shown on the picture:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page6/mesh_regular_structure.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page6/mesh_regular_structure.jpg)

The vertices array contains the collection of vertices in the mesh as native Actionscript Point instances, without duplication and without any particular order.

The triangles array stores triangles as sequence of triplet of indices pointing in the previous vertices array. It means that the cells 0,1,2 contain the indices of vertices for the 1st triangle, the cells 3,4,5 contain the indices of vertices for the 2nd triangle and so on. In addition, every triplet is ordered in a way to have vertices in counter-clockwise order.

### Extraction ###

Use the static:

`DDLSTools.extractMeshFromBitmap(bmpData:BitmapData, vertices:Vector.<Point>, triangles:Vector.<int>):void`

example:

```
// instanciate your bitmap
var bmp = new MyBmpClass();

// you need to instanciate your containers:
var vertices:Vector.<Point> = new Vector.<Point>();
var triangles:Vector.<int> = new Vector.<int>();

// then extract
DDLSTools.extractMeshFromBitmap(bmp.bitmapData, vertices, triangles);
```

Then your containers will stores the whole mesh datas as result of the vectorization and triangulation of your bitmap.

For example, you could use these datas to draw the mesh on screen:
```
var screenMesh:Sprite = new Sprite();
addChild(screenMesh);
screenMesh.graphics.lineStyle(1, 0xFF0000);
for (var i:int=0 ; i<triangles.length ; i+=3)
{
	screenMesh.graphics.moveTo(vertices[triangles[i]].x, vertices[triangles[i]].y);
	screenMesh.graphics.lineTo(vertices[triangles[i+1]].x, vertices[triangles[i+1]].y);
	screenMesh.graphics.lineTo(vertices[triangles[i+2]].x, vertices[triangles[i+2]].y);
	screenMesh.graphics.lineTo(vertices[triangles[i]].x, vertices[triangles[i]].y);
}
```

From the following image:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page6/example.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page6/example.jpg)

You would obtain the following result:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page6/result.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page6/result.jpg)
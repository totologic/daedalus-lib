After triangulations building, we are ready to process some pathfinding.

### Set an entity ###

`DDLSEntityAI` is the class you must use in order to incarnate your moving object. More precisely, because an instance of `DDLSEntityAI` class doesn't have any graphic or physic properties, you can consider it as an abstraction of your object.

To process a pathfinding, only few properties must be set on entities, as shown in the following example:

```
var entityAI: DDLSEntityAI = new DDLSEntityAI();
entityAI.radius = 10;
entityAI.x = 40; 
entityAI.y = 50;
```

A `DDLSEntityAI` instance is always shaped as a circle, so it has a radius property. It will be used by the pathfinder to make sure your entity keep a minimum distance from the constraints when solving the path resolution. Maybe your real object (graphic or physic) is not shaped as a circle, so you must choose the most relevant size for your need. For example you could use a radius value that makes the circle shape bounding closely your object  ; in consequence you are sure that no part of your object will hit a constraint when following the path.

Remember that you are free to use many `DDLSEntityAI` instances in your application, each having his own radius value.

x and y properties match the current position of your entity. Positions must be considered as expressed in the global coordinates system of the `DDLSMesh` instance your entity is living in.


### Solve a path ###

Given a `DDLSMesh` instance populated with constraints and a `DDLSEntityAI` instance, you will use the `DDLSPathfinder` class to solve path requests through the method:

`findPath(toX:Number, toY:Number, resultPath:Vector.<Number>):void`

example:
```
example:
var pathfinder: DDLSPathFinder = new DDLSPathFinder();
pathfinder.entity = entityAI;
pathfinder.mesh = mesh;
var path:Vector.<Number> = new Vector.<Number>();
pathfinder.findpath(530, 460, path);
```

The first step is to reference your entity and your mesh to your pathfinder.

Then you need a path container ; an empty `Vector.<Number>` that will contain the result of your pathfinding request.

Then, run the `findpath` method, giving destination coordinates and the path container as arguments. The path is solved from the current entity position.

As a result, the path container should now list the coordinates of the path as pairs of (x, y) values. In consequence, a way to trace the path would be:

```
for (var i:int=0 ; i<path.length/2 ; i++)
{
	trace(i , "th point");
	trace("x:" , path[i*2]);
	trace("y:" , path[i*2+1] );
}
```

example of path ; the purple dots show you the path coordinates:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page4/path.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page4/path.jpg)

Literally, the coordinates stored in path have the form:

`[p0_x, p0_y, p1_x, p1_y, ..., pn_x, pn_y]`

Notice that:
  * `(p0_x, p0_y)` is the start position
  * `(pn_x, pn_y)` is the destination position
  * path has length 0 if no path was found

### Path sampling ###

Depending of the use you do in your application, you could need to iterate through the path within a fixed distance each step. The `DDLSLinearPathSampler` can do it for you.

example:
```
var pathSampler:DDLSLinearPathSampler = new DDLSLinearPathSampler();
pathSampler.samplingDistance = 5;
pathSampler.path = path;

while (pathSampler.hasNext)
{
	pathSampler.next();
	trace(pathSampler.x, pathSampler.y);
}
```

Additionally, you could reference your entity to the path sampler and have it automatically updated:

```
var pathSampler:DDLSLinearPathSampler = new DDLSLinearPathSampler();
pathSampler.entity = entityAI;
pathSampler.samplingDistance = 5;
pathSampler.path = path;

while (pathSampler.hasNext)
{
	pathSampler.next();
	trace(entityAI.x, entityAI.y);
}
```

example of sampled path ; the purple dots show you the sampling steps:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page4/path_sampled.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page4/path_sampled.jpg)

[Next : Display debug view for your paths and entities](SimpleView2.md)
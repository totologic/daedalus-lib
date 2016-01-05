Although triangulations are rarely used directly for display, it is useful to have some tools showing them for debug.

### Simple view ###

Assuming you have instanciated and populated a `DDLSMesh` object, you can use the `DDLSSimpleView` class to quickly see the resulting triangulation.

example:
```
var view:DDLSSimpleView = new DDLSSimpleView();
addChild(view.surface);

view.drawMesh(mesh);
```

A default viewport is created for you, you must add it to the display list to see the result. Then call the `drawMesh()` method every time you need to refresh the display of your triangulation.


example of a display with a maze mesh:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page2/show_view.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page2/show_view.jpg)

Constrained edges are drawn in red whereas underlying triangulation's edges are in gray.

[Next : Build triangulations from image vectorizations](ModelisationBitmapData.md)
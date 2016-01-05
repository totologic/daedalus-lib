Although your paths and entities are rarely used directly for display, it is useful to have some tools showing them for debug.

### Simple view ###

Assuming you have instanciated some `DDLSEntityAI` objects and have solved some path datas, you can use the `DDLSSimpleView` class to quickly see them.

example:
```
var view:DDLSSimpleView = new DDLSSimpleView();
addChild(view.surface);

view.drawEntity(entityAI);
view.drawPath(path);
```

Notice that you can use a single `DDLSSimpleView` instance to display at the same time your triangulation, entities and paths.

example of display, entity is in green and path is purple:

![https://daedalus-lib.googlecode.com/svn/wiki/img/page5/show_view2.jpg](https://daedalus-lib.googlecode.com/svn/wiki/img/page5/show_view2.jpg)


[Next : Extract mesh datas from triangulated bitmap](MeshDatasExtractionFromBitmap.md)
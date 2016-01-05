### What is Daedalus Lib about ? ###

The first motivation behind Daedalus was to build a compliant library for 2D game pathfinding. By my experience and after deep investigation, it appeared that pathfinding is not just about algorithms like A-star ; because you can't build a relevant pathfinding system without a relevant data representation for your environment. Many data representations are in competition, among them: tile based, graph based, mesh based... But everything I found had many drawbacks: lack of efficiency for large environment, complexity, need of pre-generated datas...

Finally the best approach I found was in the thesis of Douglas Jon Demyen(1). It deals with triangulated environments and pathfinding through them. After more deep investigation, I was convinced it was the good way to go, because many papers from research(2)(3) described how to build efficient and fully dynamic triangulated environments. Technically, we call it _fully dynamic constrained Delaunay triangulation_.

So Daedalus Lib is at first a library dealing with _fully dynamic constrained Delaunay triangulation_ and it could be considered just for that. I hope it does a good job for that purpose, having an original API making things easy and convenient to do.

For people having pathfinding in mind and being not expert on computational geometry concepts, I hope Daedalus Lib will keep the complexity inside the box and give them simple tools to request pathfinding.

### How do I begin ? ###

First, you must be able to build a triangulation that reflect your level design. This is because the pathfinding methods in Daedalus Lib can only be requested on triangulations implemented in Daedalus Lib itself.

It doesn't mean that Daedalus Lib must be your primary level data structure. You can for example update a Daedalus Lib triangulation from a tile based level structure or a physic engine instance. Daedalus Lib is designed to be complementary and it implements convenient methods allowing you to easily maintain a triangulation while your main game engine is running.

[Next : Basic tools to build triangulations](ModelisationBasics.md)


---


Références:
  * (1) [Efficient Triangulation-Based Pathfinding by Douglas Jon Demyen](https://dl.dropboxusercontent.com/u/84854464/totologic/thesis_demyen_2006.pdf)
  * (2) [Fully Dynamic Constrained Delaunay Triangulations by Kallmann, Bieri and Thalmann](https://dl.dropboxusercontent.com/u/84854464/totologic/fully_dynamic_constrained_delaunay_triangulation.pdf)
  * (3) [An improved incremental algorithm for constructing... by Marc Vigo Anglada](https://dl.dropboxusercontent.com/u/84854464/totologic/An%20Improved%20Incremental%20Algorithm%20for%20Constructing.pdf)
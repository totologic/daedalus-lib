Direct download:
[Sources and demos](https://dl.dropboxusercontent.com/u/84854464/daedalus_sources.zip)

Daedalus Lib manages 2D environment modeling and pathfinding.

When I began to code Daedalus, I had many ideas in mind:

  1. focus on 2D
  1. fastness and accuracy
  1. simplicity of use


Why focus only on 2D and not on 3D ? Because constraining to 2D allows to gain simplicity and efficiency. Many great games today are still based on 2D engines involving 2D mechanics, 2D physics and 2D display ; so I hope Daedalus will find his place as a new component for new 2D projects.


Fastness and accuracy are reached by using among the best techniques available in the field of computational geometry : half-edge structure and fully dynamic Delaunay triangulation. Daedalus algorithms are based on many research publications, among them:

  * [Efficient Triangulation-Based Pathfinding by Douglas Jon Demyen](https://dl.dropboxusercontent.com/u/84854464/totologic/thesis_demyen_2006.pdf)
  * [Fully Dynamic Constrained Delaunay Triangulations by Kallmann, Bieri and Thalmann](https://dl.dropboxusercontent.com/u/84854464/totologic/fully_dynamic_constrained_delaunay_triangulation.pdf)
  * [An improved incremental algorithm for constructing... by Marc Vigo Anglada](https://dl.dropboxusercontent.com/u/84854464/totologic/An%20Improved%20Incremental%20Algorithm%20for%20Constructing.pdf)


For simplicity, I assumed that the library should work without any pre-generated data. Everything should work in real time : constraints insertion/motion/deletion and path generation. Also I assumed that the library should be fault tolerant to designer/developer mistakes : obstacles are clipped, can overlap and can be of any shape : open, convex, concave... At last, the path generation can manage any number of circle-shaped objects in order to avoid any obstacle collision.

Want to learn more ? [Read wiki introduction](Overview.md)
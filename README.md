# fs-dart-tools

## Graph

Utilities for creating and using graphs.  Originally written to be consumed by [tools from dart-lang-tools](https://pub.dev/packages/graphs)

## Graph implementations

This currently implements weak sauce versions of the following models. All of the implementations support generics so that you can use your own `Node` and `Edge` implementations.

Simple `Node<T>`  and `Edge<N>` are provided.  They let you put data on your node or edge.  The latter is useful if you wanted something like weights on edges.

| Implementation | Class| Directed _edges_ | Undirected _edges_ | Multiple _edges_[1] | Edge data[2] | Notes|
| - | - | - | - | - | - | - |
| Adjacency List | DirectedGraphAdjacencyList | Yes | Slow | Yes [3] | No |  This is a denormalized directed graph representation _by design_.  |
| Adjacency Matrix | AdjacencyMatrix | Yes | Yes | No | Yes [5] | This is a matrix graph representation.  Edges can be added as directed or undirected.   |
| Edge List | DirectedGraphEdgeList | Yes | Slow | Yes [4] |  Yes [5] | This is a normalized graph representation. |
| Edge List | UndirectionalGraphEdgeList | Yes | Yes | Yes [4] | Yes [5] | This is a normalized graph representation where all the edges are treated as bi-directional. |

Notes

1. Multiple edges means multiple edges are supported between two nodes
1. Data can be stored on the edge itself
1. Reverse direction only.
1. Must be of different generic types.  `DirectedGraphEdge<Owner>` and `DirectedGraphEdge<Renter>`.  These still support your custom node types or arbitratrary edge data.
1. Edges data can be of different types

### Directional Edges

Some of the graph storage implementations lend themselves to directed graphs. They support reverse or nondirected edges functions in inefficient manners.  Some of this can be overcome by adding two edges, one in each direction.

Some of the graph storage implementations are hard wired to be _undirected_.  They don't actually support one way _directed_ graphs.

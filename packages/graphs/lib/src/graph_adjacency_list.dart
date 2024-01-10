// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.
//
// See https://en.wikipedia.org/wiki/Adjacency_list
// This only requires one class because we only do Node comparisons
//
// To Do:
// 1. Hide instance variables
// 2. Copy passed in structures
//

/// A representation of a directed graph.
///
/// [nodesNextTo] can be used as a edges function for directed graphs.
/// It can support undirected graphs by adding reverse direction relationships
/// for each forward relationship
/// or by using the, inefficient, bi-directional edge walker [nodesAdjacent]
///
/// Data is stored only on nodes because there are no concrete edge objects.
/// This supports orphan nodes with no edges.
///
/// [T] is the Node type
class DirectedGraphAdjacencyList<T> {
  /// a Set because this model only supports one directed from-to per pair
  final Map<T, Set<T>> nodesAndEdges = {};

  /// Shallow copies the past in collection
  DirectedGraphAdjacencyList(Map<T, Set<T>> initialEdges) {
    _mergeEdges(initialEdges, nodesAndEdges);
  }

  /// replaces any edges on T with Set<T>
  void mergeEdges(Map<T, Set<T>> newEdges) {
    _mergeEdges(newEdges, nodesAndEdges);
  }

  /// Returns the nodes on the _to_ side of an edge _from_ [aNode].
  /// This is a directed `edges` function for this graph
  Iterable<T> nodesNextTo(T aNode) => nodesAndEdges[aNode] ?? [];

  /// Returns the nodes next to [aNode] on either side of a _from_ or _to_
  /// This is an undirected `edges` function for this graph
  Iterable<T> nodesAdjacent(T aNode) {
    final results = nodesNextTo(aNode).toSet();

    // now we look for nodes pointing _at_ aNode
    results.addAll(
      nodesAndEdges.keys
          .map((key) => nodesAndEdges[key]!.contains(aNode) ? key : null)
          .whereType<T>(),
    );

    return results;
  }

  @override
  String toString() {
    final returnBuffer = StringBuffer();
    nodesAndEdges.forEach((key, value) {
      returnBuffer.writeln('{ node:{$key}, edges:{$value}');
    });
    return returnBuffer.toString();
  }
}

// copies the initialEdges into nodes as a shallow copy
void _mergeEdges<T>(Map<T, Set<T>> initialEdges, Map<T, Set<T>> nodes) {
  nodes.addAll(Map<T, Set<T>>.from(initialEdges));
}

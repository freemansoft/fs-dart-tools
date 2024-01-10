// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.
//
// See https://en.wikipedia.org/wiki/Edge_list
// This rquires two classes because Edge equality and hashcode
// take directionality into account or they ignore it
//
// To Do:
// 1. Hide instance variables
//

import 'graph_edge.dart';
import 'graph_node.dart';

/// A representation of a directed graph.
///
/// Graph is stored as a set of [DirectedGraphEdge].
/// Each edge relates two [GraphNode] objects.
///
/// [nodesNextTo] can be used as a edges function for directed graphs.
/// It can support undirected graphs by adding reverse direction relationships
/// for each forward relationship, adding two [DirectedGraphEdge] for each.
///
/// Data is stored on [GraphNode] and [GraphEdge] objects.
/// [N] is the [GraphNode] data type. [T] is the [GraphEdge] data type.
/// This does NOT support orphan [GraphNode] with no edges.
class DirectedGraphEdgeList<N, T> {
  final Set<DirectedGraphEdge<N, T>> edges = {};

  DirectedGraphEdgeList(Set<DirectedGraphEdge<N, T>> newEdges) {
    _mergeDirectedEdges(existingEdges: edges, newEdges: newEdges);
  }

  /// Adds edges to existing graph
  /// Replaces existing edges for a from-to pair
  void mergeEdges(Set<DirectedGraphEdge<N, T>> newEdges) {
    _mergeDirectedEdges(existingEdges: edges, newEdges: newEdges);
  }

  /// Returns the nodes on the _to_ side of an edge _from_ [aNode]
  /// This is essentially the `edges` function for this graph
  Iterable<GraphNode<N>> nodesNextTo(GraphNode<N> aNode) =>
      edges.map((e) => e.from == aNode ? e.to : null).nonNulls;

  /// Returns the directed edges leaving [aNode] to any node
  Iterable<DirectedGraphEdge<N, T>> edgesNextTo(GraphNode<N> aNode) =>
      edges.map((e) => e.from == aNode ? e : null).nonNulls;

  /// Returns the directed edges from [aNode] to [bNode]
  Iterable<DirectedGraphEdge<N, T>> edgesTo(
    GraphNode<N> aNode,
    GraphNode<N> bNode,
  ) =>
      edges.map((e) => e.from == aNode && e.to == bNode ? e : null).nonNulls;

  @override
  String toString() {
    final returnBuffer = StringBuffer();
    for (var element in edges) {
      returnBuffer.writeln(' ${_fixedWidthString(element.from)} '
          '${_fixedWidthString(element.to)} '
          '${_fixedWidthString(element.data.toString())} '
          '');
    }

    return returnBuffer.toString();
  }
}

String _fixedWidthString(Object o, {maxCellWidth = 10}) =>
    o.toString().padRight(maxCellWidth).substring(0, maxCellWidth);

void _mergeDirectedEdges(
    {required Set<DirectedGraphEdge> existingEdges,
    required Set<DirectedGraphEdge> newEdges}) {
  // ignore: avoid_function_literals_in_foreach_calls
  newEdges.forEach((oneEdge) {
    if (!existingEdges.contains(oneEdge)) {
      existingEdges.add(oneEdge);
    } else {
      // Replaces the existing.
      existingEdges.add(oneEdge);
    }
  });
}

/// A representation of an undirected graph.
///
/// This knows it is undirected and behaves accordingly
/// There is no need to add two directional edges to represent an undirectional
///
/// Graph is stored as a set of [UndirectedGraphEdge].
/// Each edge relates two [GraphNode]
///
/// [nodesAdjacent] can be used as an edges function for undirected graphs.
///
/// Data is stored on [GraphNode] and [GraphEdge] objects.
/// [N] is the [GraphNode] data type. [T] is the [GraphEdge] data type.
/// This does NOT support orphan [GraphNode] with no edges.
class UndirectedGraphEdgeList<N, T> {
  final Set<UndirectedGraphEdge<N, T>> edges = {};

  UndirectedGraphEdgeList(Set<UndirectedGraphEdge<N, T>> newEdges) {
    _mergeUndirectedEdges(existingEdges: edges, newEdges: newEdges);
  }

  /// Adds edges to existing graph
  /// Replaces existing edges for a from-to pair
  void mergeEdges(Set<UndirectedGraphEdge<N, T>> newEdges) {
    _mergeUndirectedEdges(existingEdges: edges, newEdges: newEdges);
  }

  /// Returns nodes next to [aNode] in any relationship
  /// This is essentially the `edges` function for this graph
  Iterable<GraphNode<N>> nodesAdjacent(GraphNode<N> aNode) => edges
      .map(
        (e) => (e.from == aNode)
            ? e.to
            : (e.to == aNode)
                ? e.from
                : null,
      )
      .nonNulls;

  /// Returns all edges next to [aNode] undirected, in any relationship
  Iterable<GraphEdge<N, T>> edgesAdjacent(GraphNode<N> aNode) => edges
      .map(
        (e) => (e.from == aNode) || (e.to == aNode) ? e : null,
      )
      .nonNulls;

  /// Returns edges between [aNode] and [bNode] undirected, in any relationship
  Iterable<UndirectedGraphEdge<N, T>> edgesBetween(
    GraphNode<N> aNode,
    GraphNode<N> bNode,
  ) =>
      edges
          .map(
            (e) => (e.from == aNode && e.to == bNode) ||
                    e.from == aNode && e.to == bNode
                ? e
                : null,
          )
          .nonNulls;

  @override
  String toString() => edges.toString();
}

void _mergeUndirectedEdges(
    {required Set<UndirectedGraphEdge> existingEdges,
    required Set<UndirectedGraphEdge> newEdges}) {
  // ignore: avoid_function_literals_in_foreach_calls
  newEdges.forEach((oneEdge) {
    if (!existingEdges.contains(oneEdge)) {
      existingEdges.add(oneEdge);
    } else {
      // Replaces the existing.
      existingEdges.add(oneEdge);
    }
  });
}

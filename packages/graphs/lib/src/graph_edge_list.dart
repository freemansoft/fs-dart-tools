// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.
//
// See https://en.wikipedia.org/wiki/Edge_list
// This rquires two classes because Edge equality and hashcode
// take directionality into account or they ignore it
//
// Future:
// 1. addEdge() - new [GraphNode] are implied by an edge
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
  final Set<DirectedGraphEdge<N, T>> edges;

  DirectedGraphEdgeList(this.edges);

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
  String toString() => edges.toString();
}

/// A representation of an undirected graph.
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
  final Set<UndirectedGraphEdge<N, T>> edges;

  UndirectedGraphEdgeList(this.edges);

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

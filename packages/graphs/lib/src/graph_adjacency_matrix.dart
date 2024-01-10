// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.
//
// See https://en.wikipedia.org/wiki/Adjacency_matrix
//
// To Do:
// 1. Hide instance variables
//
import 'package:collection/collection.dart';

/// An immutable AdjacencyMatrix -- cannot be added too
///
/// [N] is the Node Type - must implement equals and hash for identity
///
/// [T] is the Edge Type
class AdjacencyMatrix<N, T> {
  /// tells us the rank of the Node, its index into the edgeMatrix
  Map<N, int> nodeMap = {};

  /// tells us the Node at a given index
  Map<int, N> rankMap = {};

  /// Row major order storage for the matrix in a 1D list.
  /// Empty cells mean there is no edge there
  ///
  List<T?> edgeMatrix = [];

  /// Constructors can't call any instance methods in dart :-(
  ///
  /// Using [MatrixEdgeDef] because it gives us the three parts we need
  /// 'from', 'to' and 'edge' data in a single object.
  ///
  AdjacencyMatrix(
    Set<MatrixEdgeDef<N, T>> edges,
  ) {
    edgeMatrix = _mergeEdges<N, T>(
        edges: edges,
        nodeToIndex: nodeMap,
        indexToNode: rankMap,
        existingEdges: edgeMatrix);
  }

  /// Explicitly adds edges.  Implicitly adds nodes. Replaces existing edge.
  /// This is expensive because it builds a new matrix.
  /// Add as many as you can at at a time to reduce resizing.
  void mergeEdges(Set<MatrixEdgeDef<N, T>> edges) {
    edgeMatrix = _mergeEdges<N, T>(
        edges: edges,
        nodeToIndex: nodeMap,
        indexToNode: rankMap,
        existingEdges: edgeMatrix);
  }

  /// Returns the nodes on the _to_ side of an edge _from_ [aNode]
  /// This is essentially the `edges` function for a directed graph
  Iterable<N> nodesNextTo(N aNode) {
    final rank = this.nodeMap[aNode];
    // return nothing if the node isn't in the graph
    if (rank == null) {
      return Iterable<N>.empty();
    }
    // Walk all the _to_ relationships looking for non null
    final forwardNodes = Iterable<N?>.generate(
      nodeMap.length,
      (index) => (edgeMatrix[_calculateLocationFromRank(
                fromRank: rank,
                toRank: index,
                rankSize: nodeMap.length,
              )] !=
              null)
          ? rankMap[index]
          : null,
    ).whereType<N>();
    return forwardNodes;
  }

  /// Returns nodes next to [aNode] in any relationship
  /// This is essentially the `edges` function an undirected graph
  Iterable<N> nodesAdjacent(N aNode) {
    final forwardNodes = nodesNextTo(aNode);

    final rank = this.nodeMap[aNode];
    // return nothing if the node isn't in the graph
    if (rank == null) {
      return Iterable<N>.empty();
    }
    // Walk all the _to_ relationships looking for non null
    final backwardsNodes = Iterable<N?>.generate(
      nodeMap.length,
      (index) => (edgeMatrix[_calculateLocationFromRank(
                fromRank: index,
                toRank: rank,
                rankSize: nodeMap.length,
              )] !=
              null)
          ? rankMap[index]
          : null,
    ).whereType<N>();

    final foo = Set<N>.from(forwardNodes)..addAll(backwardsNodes);
    return foo;
  }

  /// Returns the directed edges from [aNode] to [bNode]
  /// Iteration should only contain one  or zero items at this time
  Iterable<T> edgesTo(
    N aNode,
    N bNode,
  ) {
    if (!this.nodeMap.containsKey(aNode) || !this.nodeMap.containsKey(bNode)) {
      // return nothing if the node isn't in the graph
      return Iterable<T>.empty();
    }
    final rankFrom = this.nodeMap[aNode]!;
    final rankTo = this.nodeMap[bNode]!;

    final forwardNodes = {
      edgeMatrix[_calculateLocationFromRank(
        fromRank: rankFrom,
        toRank: rankTo,
        rankSize: nodeMap.length,
      )],
    }.whereType<T>();
    return forwardNodes;
  }

  /// Returns edges between [aNode] and [bNode] undirected, in any relationship
  /// Iteration should only contain two, one or zero items at this time
  Iterable<T> edgesBetween(
    N aNode,
    N bNode,
  ) {
    if (!this.nodeMap.containsKey(aNode) || !this.nodeMap.containsKey(bNode)) {
      // return nothing if the node isn't in the graph
      return Iterable<T>.empty();
    }
    final rankFrom = this.nodeMap[aNode]!;
    final rankTo = this.nodeMap[bNode]!;

    final forwardNodes = {
      edgeMatrix[_calculateLocationFromRank(
        fromRank: rankFrom,
        toRank: rankTo,
        rankSize: nodeMap.length,
      )],
      edgeMatrix[_calculateLocationFromRank(
        fromRank: rankTo,
        toRank: rankFrom,
        rankSize: nodeMap.length,
      )],
    }.whereType<T>();
    return forwardNodes;
  }

  @override
  String toString() {
    final result = StringBuffer();
    result.write('[');
    result.write(' ${_fixedWidthString('')} , ');
    for (var j = 0; j < nodeMap.length; j++) {
      result.write('"${_fixedWidthString(rankMap[j]!)}", ');
    }
    result.writeln('],');
    for (var i = 0; i < nodeMap.length; i++) {
      result.write('[');
      result.write('"${_fixedWidthString(rankMap[i]!)}", ');
      for (var j = 0; j < nodeMap.length; j++) {
        final edgeValue = edgeMatrix[_calculateLocationFromRank(
          fromRank: i,
          toRank: j,
          rankSize: nodeMap.length,
        )];
        (edgeValue == null)
            ? result.write(' ${_fixedWidthString('')} , ')
            : result.write(
                '"${_fixedWidthString(edgeValue)}", ',
              );
      }
      result.writeln('],');
    }
    return result.toString();
  }
}

/// Adds edges to an existing matrix.
/// Adds nodes as needed to store the edges
List<T?> _mergeEdges<N, T>(
    {required Set<MatrixEdgeDef<N, T>> edges,
    required Map<N, int> nodeToIndex,
    required Map<int, N> indexToNode,
    required List<T?> existingEdges}) {
  final oldNumNodes = nodeToIndex.length;

  // Find all the nodes in all the edges
  // Use a set to dedupe
  // Create a map from the Node to its position
  // Do NOT replace existing node with a new one because will change the index.
  var newNodeToIndexEntries = edges
      .map((e) => [e.from, e.to])
      .flattened
      .whereType<N>()
      .toSet()
      .mapIndexed((index, node) => nodeToIndex.containsKey(node)
          ? null
          : MapEntry(node, index + oldNumNodes))
      .nonNulls;
  nodeToIndex.addEntries(newNodeToIndexEntries);
  // rankMap is nodeMap inverted
  indexToNode.clear();
  indexToNode
      .addEntries(nodeToIndex.entries.map((e) => MapEntry(e.value, e.key)));

  // create the empty matrix
  List<T?> edgeMatrix =
      List.filled(nodeToIndex.length * nodeToIndex.length, null);
  // copy the old matrix into it
  for (int fromRank = 0; fromRank < oldNumNodes; fromRank++) {
    for (int toRank = 0; toRank < oldNumNodes; toRank++) {
      edgeMatrix[_calculateLocationFromRank(
              fromRank: fromRank,
              toRank: toRank,
              rankSize: nodeToIndex.length)] =
          existingEdges[_calculateLocationFromRank(
              fromRank: fromRank, toRank: toRank, rankSize: oldNumNodes)];
    }
  }

  // fill adjacency matrix with the new edges
  // ignore: avoid_function_literals_in_foreach_calls
  edges.forEach(
    (e) {
      if ((e.to == null && e.edgeData != null) ||
          (e.to != null && e.edgeData == null)) {
        throw InvalidMatrixEdgeDef(e);
      }
      if (e.to != null) {
        edgeMatrix[_calculateLocationFromRank(
          fromRank: nodeToIndex[e.from]!,
          toRank: nodeToIndex[e.to]!,
          rankSize: nodeToIndex.length,
        )] = e.edgeData;
        if (!e.directed) {
          edgeMatrix[_calculateLocationFromRank(
            fromRank: nodeToIndex[e.to]!,
            toRank: nodeToIndex[e.from]!,
            rankSize: nodeToIndex.length,
          )] = e.edgeData;
        }
      }
    },
  );

  return edgeMatrix;
}

// each cell is limited to a width of
const _maxCellWidth = 10;

String _fixedWidthString(Object o) =>
    o.toString().padRight(_maxCellWidth).substring(0, _maxCellWidth);

int _calculateLocationFromRank({
  required int fromRank,
  required int toRank,
  required int rankSize,
}) =>
    fromRank * rankSize + toRank;

/// Needed a model class for the constructor that accepts a whole graph.
/// Covering for the fact we don't have Tuples
///
/// * [to] and [edgeData] can be null if this is an orphan node
/// * [to] is required if [edgeData] is provided
/// * [edgeData] is required if [to] is provided
///
class MatrixEdgeDef<N, T> {
  final N from;
  final N? to;
  final T? edgeData;
  final bool directed;

  MatrixEdgeDef({
    required this.from,
    this.to,
    this.edgeData,
    this.directed = true,
  });
}

class InvalidMatrixEdgeDef<MatrixEdgeDef> implements Exception {
  final MatrixEdgeDef edge;

  InvalidMatrixEdgeDef(this.edge);

  @override
  String toString() => 'A MatrixEdgeDef had a constraint violation $edge';
}

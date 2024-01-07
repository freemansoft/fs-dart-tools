// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.
//
// See https://en.wikipedia.org/wiki/Adjacency_matrix
//
// Future:
// 1. addGraphNode()
// 2. addRelationship()
//
import 'package:collection/collection.dart';

/// An immutable AdjacencyMatrix -- cannot be added too
///
/// [N] is the Node Type
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
    // Find all the nodes in all the edges
    // Use a set to dedupe
    // Create a map from the Node to its position
    nodeMap.addEntries(
      edges
          .map((e) => [e.from, e.to])
          .flattened
          .whereType<N>()
          .toSet()
          .mapIndexed((index, node) => MapEntry(node, index)),
    );
    // rankMap is nodeMap inverted
    rankMap.addEntries(nodeMap.entries.map((e) => MapEntry(e.value, e.key)));

    // create the empty matrix
    edgeMatrix = List.filled(nodeMap.length * nodeMap.length, null);

    // now start filling adjacency matrix with edges
    // ignore: avoid_function_literals_in_foreach_calls
    edges.forEach(
      (e) {
        if ((e.to == null && e.edgeData != null) ||
            (e.to != null && e.edgeData == null)) {
          throw InvalidMatrixEdgeDef(e);
        }
        if (e.to != null) {
          edgeMatrix[_calculateLocationFromRank(
            fromRank: nodeMap[e.from]!,
            toRank: nodeMap[e.to]!,
            rankSize: nodeMap.length,
          )] = e.edgeData;
          if (!e.directed) {
            edgeMatrix[_calculateLocationFromRank(
              fromRank: nodeMap[e.to]!,
              toRank: nodeMap[e.from]!,
              rankSize: nodeMap.length,
            )] = e.edgeData;
          }
        }
      },
    );

    // need to fix this
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

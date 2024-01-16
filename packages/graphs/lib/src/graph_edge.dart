// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.
//
// See https://en.wikipedia.org/wiki/Edge_list
// This rquires two classes because Edge equality and hashcode
// take directionality into account or they ignore it

import 'package:fs_graphs/src/graph_node.dart';
import 'package:meta/meta.dart';

/// An [GraphEdge] epresents the relationship of two nodes.
///
/// [N] is the [GraphNode] because it we're lazy and it contains `from` and `to`
///
/// [T] is the [GraphEdge] data type
abstract class GraphEdge<N, T> {
  /// Default constructor
  ///
  /// [from] start of an edge if directed.  Just an end if undirected.
  ///
  /// [to] end of an edge if directed.  Just an end if undirected.
  ///
  /// [data] data or metadata about the edge.  Ex: edge weight
  GraphEdge({required this.from, required this.to, this.data});

  /// The _from_ part of a directed edge or just an end of an edge if undirected
  final GraphNode<N> from;

  /// The _to_ part of a directed edge or just an end of an edge if undirected
  final GraphNode<N> to;

  /// Metadata or data tied to the edge.  Ex: edge weight
  final T? data;

  @override
  String toString() {
    if (data == null) {
      return '<$from -> $to>';
    } else {
      return '<$from -> $to : $data>';
    }
  }
}

/// An [GraphEdge] epresents the relationship of two nodes.
/// A [DirectedGraphEdge] treates that relationship as directional
/// equals and hashcode are implemented taking into account direction
@immutable
class DirectedGraphEdge<N, T> extends GraphEdge<N, T> {
  DirectedGraphEdge({required super.from, required super.to, super.data});

  /// Includes the data type [runtimeType] but not the data.
  /// Two edges between the same nodes of the same type represent the same edge
  @override
  bool operator ==(Object other) =>
      // Includes the runtime type because that takes into account generics
      other is DirectedGraphEdge &&
      runtimeType == other.runtimeType &&
      other.from == from &&
      other.to == to;

  /// Includes the data type [runtimeType] but not the data.
  /// Two edges between the same nodes of the same type represent the same edge
  @override
  int get hashCode {
    // Includes the runtime type because that takes into account generics
    final typeHash = runtimeType.hashCode;
    final fromHash = from.hashCode;
    final toHash = to.hashCode;
    return '$typeHash:$fromHash:$toHash'.hashCode;
  }
}

/// An [GraphEdge] epresents the relationship of two nodes.
/// An [UndirectedGraphEdge] treates that relationship without direction

/// equals and hashcode are implemented ignoring direction
/// from and to are just names without directional meaning
@immutable
class UndirectedGraphEdge<N, T> extends GraphEdge<N, T> {
  UndirectedGraphEdge({required super.from, required super.to, super.data});

  /// Includes the data type [runtimeType] but not the data.
  /// Two edges between the same nodes of the same type represent the same edge
  @override
  bool operator ==(Object other) =>
      // Includes the runtime type because that takes into account generics
      other is UndirectedGraphEdge &&
      runtimeType == other.runtimeType &&
      ((other.from == from && other.to == to) ||
          (other.from == to && other.to == from));

  /// Includes the data type [runtimeType] but not the data.
  /// Two edges between the same nodes of the same type represent the same edge
  @override
  int get hashCode {
    // Includes the runtime type because that takes into account generics
    final typeHash = runtimeType.hashCode;
    final fromHash = from.hashCode;
    final toHash = to.hashCode;
    // always put the smaller node hash first to be undirected
    if (toHash < fromHash) {
      return '$typeHash:$toHash:$fromHash'.hashCode;
    } else {
      return '$typeHash:$fromHash:$toHash'.hashCode;
    }
  }
}

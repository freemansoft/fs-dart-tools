// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.

import 'package:graphs/graphs.dart';
import 'package:fs_graphs/graphs.dart';

/// Uses representation of a directed graph implemented as an adjacency list.
///
void main() {
  final nodeA = GraphNode(id: 'A', data: 1);
  final nodeB = GraphNode(id: 'B', data: 2);
  final nodeC = GraphNode(id: 'C', data: 3);
  final nodeD = GraphNode(id: 'D', data: 4);
  final graph = DirectedGraphAdjacencyList({
    nodeA: {nodeB, nodeC},
    nodeB: {nodeC, nodeD},
    nodeC: {nodeB, nodeD},
  });

  print('In directed graph $nodeC next to ${graph.nodesNextTo(nodeC)}');

  final components = stronglyConnectedComponents<GraphNode<int>>(
    graph.nodes.keys,
    graph.nodesNextTo,
  );

  print('Strongly connected components $components');

  print('In undirected graph $nodeC next to ${graph.nodesAdjacent(nodeC)}');

  print('graph\n ${graph.toString()}');
}

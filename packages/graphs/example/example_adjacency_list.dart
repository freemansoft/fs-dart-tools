// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.

import 'package:fs_graphs/graphs.dart';
import 'package:graphs/graphs.dart';

/// Uses representation of a directed graph implemented as an adjacency list.
///
void main() {
  const nodeA = GraphNode(id: 'A', data: 1);
  const nodeB = GraphNode(id: 'B', data: 2);
  const nodeC = GraphNode(id: 'C', data: 3);
  const nodeD = GraphNode(id: 'D', data: 4);
  final graph = DirectedGraphAdjacencyList({
    nodeA: {nodeB, nodeC},
    nodeB: {nodeC, nodeD},
    nodeC: {nodeB, nodeD},
  });

  print('In directed graph $nodeC next to ${graph.nodesNextTo(nodeC)}');

  final components = stronglyConnectedComponents<GraphNode<int>>(
    graph.nodesAndEdges.keys,
    graph.nodesNextTo,
  );

  print('Strongly connected components $components');
  print('In undirected graph $nodeC next to ${graph.nodesAdjacent(nodeC)}');
  print('graph (initial)\n$graph');

  const nodeZZ = GraphNode(id: 'ZZ', data: 99);
  const nodeZZZ = GraphNode(id: 'ZZZ', data: 999);
  graph.mergeEdges({
    nodeZZ: {nodeZZZ},
    nodeD: {nodeZZZ},
  });
  print('graph (added)\n$graph');
}

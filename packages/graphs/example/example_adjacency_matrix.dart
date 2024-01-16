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
  const nodeE = GraphNode(id: 'E', data: 5);
  const nodeF = GraphNode(id: 'F', data: 6);

  // Capture first level relationships. Everything after that is complicated
  final graph = AdjacencyMatrix<GraphNode<int>, String>({
    MatrixEdgeDef(from: nodeA, to: nodeB, edgeData: 'parent'),
    // removed to better create a one directional relationship
    //MatrixEdgeDef(from: nodeB, to: nodeA, edgeData: 'child'),
    MatrixEdgeDef(from: nodeA, to: nodeC, edgeData: 'parent'),
    // removed to better create a one directional relationship
    //MatrixEdgeDef(from: nodeC, to: nodeA, edgeData: 'child'),
    MatrixEdgeDef(from: nodeB, to: nodeC, edgeData: 'sibling', directed: false),
    MatrixEdgeDef(from: nodeB, to: nodeD, edgeData: 'parent'),
    MatrixEdgeDef(from: nodeD, to: nodeB, edgeData: 'child'),
    MatrixEdgeDef(from: nodeC, to: nodeD, edgeData: 'uncle'),
    // added to show connectivity of node with no relationships
    MatrixEdgeDef(from: nodeE),
    MatrixEdgeDef(from: nodeF, to: nodeA, edgeData: 'cousin'),
  });

  print('AdjacencyMatrix graph\n$graph');

  print('In AdjacencyMatrix $nodeC next to ${graph.nodesNextTo(nodeC)}');

  print('In AdjacencyMatrix $nodeC adjacent to ${graph.nodesAdjacent(nodeC)}');

  final componentsNextTo = stronglyConnectedComponents<GraphNode<int>>(
    graph.nodeMap.keys,
    graph.nodesNextTo,
  );

  print('Components strongly connected directional $componentsNextTo');

  final componentsAdjacentTo = stronglyConnectedComponents<GraphNode<int>>(
    graph.nodeMap.keys,
    graph.nodesAdjacent,
  );

  print('Components strongly connected non-directional $componentsAdjacentTo');

  final shortest = shortestPath(nodeA, nodeD, graph.nodesNextTo);
  print('shortest from $nodeA to $nodeD is $shortest');

  // add a couple nodes and edges
  const nodeZZ = GraphNode(id: 'ZZ', data: 99);
  const nodeZZZ = GraphNode(id: 'ZZZ', data: 999);
  graph.mergeEdges({
    MatrixEdgeDef(from: nodeZZ, to: nodeZZZ, edgeData: '??', directed: false),
    MatrixEdgeDef(from: nodeZZ, to: nodeD, edgeData: 'discovered'),
  });

  print('AdjacencyMatrix graph\n$graph');
}

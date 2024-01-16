// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.

import 'package:fs_graphs/graphs.dart';
import 'package:graphs/graphs.dart';

/// Uses representation of a directed graph implemented as an edge list.
///
void main() {
  const nodeA = GraphNode(id: 'A', data: 1);
  const nodeB = GraphNode(id: 'B', data: 2);
  const nodeC = GraphNode(id: 'C', data: 3);
  const nodeD = GraphNode(id: 'D', data: 4);

  // added later to test merge
  const nodeZZ = GraphNode(id: 'ZZ', data: 99);
  const nodeZZZ = GraphNode(id: 'ZZZ', data: 999);

  final nodes = <GraphNode<int>>[nodeA, nodeB, nodeC, nodeD];

  final graphDirected = DirectedGraphEdgeList({
    DirectedGraphEdge(from: nodeA, to: nodeB, data: 'parent'),
    DirectedGraphEdge(from: nodeA, to: nodeC, data: 'parent'),
    DirectedGraphEdge(from: nodeB, to: nodeC, data: 'sibling'),
    DirectedGraphEdge(from: nodeB, to: nodeD, data: 'parent'),
    DirectedGraphEdge(from: nodeC, to: nodeB, data: 'sibling'),
    DirectedGraphEdge<int, void>(from: nodeC, to: nodeD),
  });

  print('Directed graph: $graphDirected');

  print(
    'Directed: $nodeB next to ${graphDirected.nodesNextTo(nodeB)}',
  );

  print(
    'Directed: edges leaving $nodeB : ${graphDirected.edgesNextTo(nodeB)}',
  );

  final components = stronglyConnectedComponents<GraphNode<int>>(
    nodes,
    graphDirected.nodesNextTo,
  );

  print('Strongly connected components $components');

  graphDirected.mergeEdges({
    DirectedGraphEdge<int, String>(
      from: nodeZZ,
      to: nodeZZZ,
      data: 'discovered',
    ),
  });
  print('Directed graph after additions: \n$graphDirected');
  print('\n');

  final graphUndirected = UndirectedGraphEdgeList({
    UndirectedGraphEdge(from: nodeA, to: nodeB, data: 'parent'),
    UndirectedGraphEdge(from: nodeA, to: nodeC, data: 'parent'),
    UndirectedGraphEdge(from: nodeB, to: nodeC, data: 'sibling'),
    UndirectedGraphEdge(from: nodeB, to: nodeD, data: 'parent'),
    UndirectedGraphEdge(from: nodeC, to: nodeB, data: 'sibling'),
    UndirectedGraphEdge<int, void>(from: nodeC, to: nodeD),
  });

  print('Undirected graph: $graphDirected');

  print('Undirected: $nodeB next to ${graphUndirected.nodesAdjacent(nodeB)}');

  print(
    'Unirected: edges leaving $nodeB : ${graphUndirected.edgesAdjacent(nodeB)}',
  );

  graphUndirected.mergeEdges({
    UndirectedGraphEdge<int, String>(
      from: nodeZZ,
      to: nodeZZZ,
      data: 'discovered',
    ),
  });
  print('Undirected graph after additions: \n$graphDirected');
}

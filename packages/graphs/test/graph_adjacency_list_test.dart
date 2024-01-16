import 'package:fs_graphs/graphs.dart';

import 'package:test/test.dart';

void main() {
  group('Directed Graph Adjacency List', () {
    test(
      'Create a directed graph and merge additional',
      () {
        const nodeA = GraphNode(id: 'A', data: 1);
        const nodeB = GraphNode(id: 'B', data: 2);
        const nodeC = GraphNode(id: 'C', data: 3);
        const nodeD = GraphNode(id: 'D', data: 4);
        final graph = DirectedGraphAdjacencyList({
          nodeA: {nodeC},
          nodeB: {nodeC},
          nodeC: {nodeA, nodeB, nodeD},
        });

        final Iterable<GraphNode<int>> nextToNodeD = graph.nodesNextTo(nodeD);
        final Iterable<GraphNode<int>> adjacentNodeD =
            graph.nodesAdjacent(nodeD);
        final Iterable<GraphNode<int>> nextToNodeC = graph.nodesNextTo(nodeC);
        final Iterable<GraphNode<int>> adjacentNodeC =
            graph.nodesAdjacent(nodeC);

        // should check the values
        expect(nextToNodeD.length, 0);
        expect(adjacentNodeD.length, 1);
        expect(nextToNodeC.length, 3);
        expect(adjacentNodeC.length, 3);

        const nodeZZ = GraphNode(id: 'zz', data: 99);
        graph.mergeEdges({
          nodeZZ: {nodeD},
        });
        final Iterable<GraphNode<int>> nextToNodeDAfter =
            graph.nodesNextTo(nodeD);
        final Iterable<GraphNode<int>> adjacentNodeDAfter =
            graph.nodesAdjacent(nodeD);

        expect(nextToNodeDAfter.length, 0);
        expect(adjacentNodeDAfter.length, 2);
      },
    );
  });
}

import 'package:fs_graphs/graphs.dart';

import 'package:test/test.dart';

void main() {
  group('Directed Graph Adjacency Matrix', () {
    test(
      'Create a directed graph and merge additional',
      () {
        final nodeA = GraphNode(id: 'A', data: 1);
        final nodeB = GraphNode(id: 'B', data: 2);
        final nodeC = GraphNode(id: 'C', data: 3);
        final nodeD = GraphNode(id: 'D', data: 4);
        final graph = AdjacencyMatrix({
          MatrixEdgeDef(from: nodeA, to: nodeC, edgeData: ''),
          MatrixEdgeDef(from: nodeB, to: nodeC, edgeData: ''),
          MatrixEdgeDef(from: nodeC, to: nodeA, edgeData: ''),
          MatrixEdgeDef(from: nodeC, to: nodeB, edgeData: ''),
          MatrixEdgeDef(from: nodeC, to: nodeD, edgeData: ''),
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

        final nodeZZ = GraphNode(id: 'zz', data: 99);
        graph.mergeEdges({
          MatrixEdgeDef(from: nodeZZ, to: nodeD, edgeData: ''),
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

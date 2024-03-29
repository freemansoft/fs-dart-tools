import 'package:fs_graphs/graphs.dart';

import 'package:test/test.dart';

void main() {
  group('Directed Graph Adjacency Matrix', () {
    test(
      'Create a directed graph and merge additional',
      () {
        const nodeA = GraphNode(id: 'A', data: 1);
        const nodeB = GraphNode(id: 'B', data: 2);
        const nodeC = GraphNode(id: 'C', data: 3);
        const nodeD = GraphNode(id: 'D', data: 4);
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

        const nodeZZ = GraphNode(id: 'zz', data: 99);
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

  test(
    'Edges can be different types',
    () {
      const nodeA = GraphNode(id: 'A', data: 1);
      const nodeB = GraphNode(id: 'B', data: 2);
      const nodeC = GraphNode(id: 'C', data: 3);
      final graph = AdjacencyMatrix({
        MatrixEdgeDef(from: nodeA, to: nodeB, edgeData: ''),
        MatrixEdgeDef(from: nodeC, to: nodeA, edgeData: 5),
      });

      final Iterable<GraphNode<int>> nextToNodeA = graph.nodesNextTo(nodeA);
      final Iterable<GraphNode<int>> adjacentNodeA = graph.nodesAdjacent(nodeA);

      // should check the values
      expect(nextToNodeA.length, 1);
      expect(adjacentNodeA.length, 2);

      expect(graph.edgesBetween(nodeA, nodeB).length, equals(1));
      expect(graph.edgesBetween(nodeA, nodeB).first, isA<String>());
      expect(graph.edgesBetween(nodeA, nodeC).length, equals(1));
      expect(graph.edgesBetween(nodeA, nodeC).first, isA<int>());
    },
  );
}

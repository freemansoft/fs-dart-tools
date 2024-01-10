import 'package:fs_graphs/graphs.dart';

import 'package:test/test.dart';

void main() {
  group('Directed Graph Adjacency List', () {
    test(
      'Create a directed graph and merge additional',
      () {
        final nodeA = GraphNode(id: 'A', data: 1);
        final nodeB = GraphNode(id: 'B', data: 2);
        final nodeC = GraphNode(id: 'C', data: 3);
        final nodeD = GraphNode(id: 'D', data: 4);
        final graph = DirectedGraphEdgeList({
          DirectedGraphEdge(from: nodeA, to: nodeC, data: ''),
          DirectedGraphEdge(from: nodeB, to: nodeC, data: ''),
          DirectedGraphEdge(from: nodeC, to: nodeA, data: ''),
          DirectedGraphEdge(from: nodeC, to: nodeB, data: ''),
          DirectedGraphEdge(from: nodeC, to: nodeD, data: ''),
        });

        final Iterable<GraphNode<int>> nextToNodeD = graph.nodesNextTo(nodeD);
        // final Iterable<GraphNode<int>> adjacentNodeD =
        //     graph..nodesAdjacent(nodeD);
        final Iterable<GraphNode<int>> nextToNodeC = graph.nodesNextTo(nodeC);
        // final Iterable<GraphNode<int>> adjacentNodeC =
        //     graph.nodesAdjacent(nodeC);

        // should check the values
        expect(nextToNodeD.length, 0);
        // expect(adjacentNodeD.length, 1);
        expect(nextToNodeC.length, 3);
        // expect(adjacentNodeC.length, 3);

        final nodeZZ = GraphNode(id: 'zz', data: 99);
        graph.mergeEdges({
          DirectedGraphEdge(from: nodeZZ, to: nodeD, data: ''),
        });
        final Iterable<GraphNode<int>> nextToNodeDAfter =
            graph.nodesNextTo(nodeD);
        // final Iterable<GraphNode<int>> adjacentNodeDAfter =
        //     graph.nodesAdjacent(nodeD);

        expect(nextToNodeDAfter.length, 0);
        // expect(adjacentNodeDAfter.length, 2);
      },
    );

    test(
      'Create a undirected graph and merge additional',
      () {
        final nodeA = GraphNode(id: 'A', data: 1);
        final nodeB = GraphNode(id: 'B', data: 2);
        final nodeC = GraphNode(id: 'C', data: 3);
        final nodeD = GraphNode(id: 'D', data: 4);
        final graph = UndirectedGraphEdgeList({
          UndirectedGraphEdge(from: nodeA, to: nodeC, data: ''),
          UndirectedGraphEdge(from: nodeB, to: nodeC, data: ''),
          UndirectedGraphEdge(from: nodeC, to: nodeA, data: ''),
          UndirectedGraphEdge(from: nodeC, to: nodeB, data: ''),
          UndirectedGraphEdge(from: nodeC, to: nodeD, data: ''),
        });

        // final Iterable<GraphNode<int>> nextToNodeD = graph.nodesNextTo(nodeD);
        final Iterable<GraphNode<int>> adjacentNodeD =
            graph.nodesAdjacent(nodeD);
        // final Iterable<GraphNode<int>> nextToNodeC = graph.nodesNextTo(nodeC);
        final Iterable<GraphNode<int>> adjacentNodeC =
            graph.nodesAdjacent(nodeC);

        // should check the values
        // expect(nextToNodeD.length, 0);
        expect(adjacentNodeD.length, 1);
        // expect(nextToNodeC.length, 3);
        expect(adjacentNodeC.length, 3);

        final nodeZZ = GraphNode(id: 'zz', data: 99);
        graph.mergeEdges({
          UndirectedGraphEdge(from: nodeZZ, to: nodeD, data: ''),
        });
        // final Iterable<GraphNode<int>> nextToNodeDAfter =
        //     graph.nodesNextTo(nodeD);
        final Iterable<GraphNode<int>> adjacentNodeDAfter =
            graph.nodesAdjacent(nodeD);

        // expect(nextToNodeDAfter.length, 0);
        expect(adjacentNodeDAfter.length, 2);
      },
    );
  });
}

// Copyright (c) 2024, Joe Freeman
// Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file.
//
// See https://en.wikipedia.org/wiki/Edge_list
// This rquires two classes because Edge equality and hashcode
// take directionality into account or they ignore it

import 'package:meta/meta.dart';

/// Generic node where the id is used for identity purposes
@immutable
class GraphNode<T> {
  const GraphNode({required this.id, this.data});
  final String id;
  final T? data;

  @override
  bool operator ==(Object other) => other is GraphNode && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '<$id : $data>';
}

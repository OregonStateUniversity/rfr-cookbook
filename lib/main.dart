import 'package:flutter/material.dart';
import 'protocol_list.dart';
import 'mocks/mock_protocols.dart';

void main() {
  final mockProtocols = MockProtocol.fetchAll();

  return runApp(MaterialApp(home: ProtocolList(mockProtocols)));
}
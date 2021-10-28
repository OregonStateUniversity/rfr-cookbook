import 'package:flutter/material.dart';
import 'mocks/mock_protocols.dart';
import 'protocol_list.dart';

void main() {
  final mockProtocols = MockProtocol.fetchAll();

  return runApp(MaterialApp(home: ProtocolList(mockProtocols)));
}
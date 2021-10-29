import '../models/protocol.dart';

mixin MockProtocol implements Protocol {
  static const _protocolData = [
    'Preface',
    'Operations',
    'Procedures',
    'Treatment',
    'Medications',
    'Trauma System',
    'Hazardous Materials',
  ];

  static final List<Protocol> _items = _protocolData.map(
    (protocol) => Protocol(name: protocol, url: 'lib/assets/$protocol.pdf')
  ).toList();

  static Protocol fetchAny() {
    return _items[0];
  }

  static List<Protocol> fetchAll() {
    return _items;
  }
}
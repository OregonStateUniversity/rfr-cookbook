import '../models/protocol.dart';

mixin MockProtocol implements Protocol {

  static const _protocolData = {
    'Preface': 'assets/Preface.pdf',
    'Operations': 'assets/Operations.pdf',
    'Procedures': 'assets/Procedures.pdf',
    'Treatment': 'assets/Treatment.pdf',
    'Medications': 'assets/Medications.pdf',
    'Trauma System': 'assets/Trauma System.pdf',
    'Hazardous Materials': 'assets/Hazardous Materials.pdf',
  };

  static final List<Protocol> _items = _protocolData.entries.map(
    (e) => Protocol(name: e.key, url: e.value)
  ).toList();

  static Protocol fetchAny() {
    return _items[0];
  }

  static List<Protocol> fetchAll() {
    return _items;
  }
}
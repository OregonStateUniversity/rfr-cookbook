import '../models/protocol.dart';

mixin MockProtocol implements Protocol {
  static final List<Protocol> _items = [
    Protocol(
      name: 'Preface',
      url: 'assets/Preface.pdf',
    ),
    Protocol(
      name: 'Operations',
      url: 'assets/Operations.pdf'
    ),
    Protocol(
      name: 'Procedures',
      url: 'assets/Procedures.pdf',
    ),
    Protocol(
      name: 'Treatment',
      url: 'assets/Treatment.pdf',
    ),
    Protocol(
      name: 'Medications',
      url: 'assets/Medications.pdf',
    ),
    Protocol(
      name: 'Trauma System',
      url: 'assets/Trauma System.pdf',
    ),
    Protocol(
      name: 'Hazardous Materials',
      url: 'assets/Hazardous Materials.pdf',
    ),
  ];

  static Protocol fetchAny() {
    return _items[0];
  }

  static List<Protocol> fetchAll() {
    return _items;
  }
}
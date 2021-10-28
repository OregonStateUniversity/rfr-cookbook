import '../models/contact.dart';

mixin MockContact implements Contact {
  static const _contactData = {
    'Kehmna, Ken': '458-256-9440',
    'Puller, Jeff': '541-410-8149',
    'Cox, Diane': '541-979-5783',
    'Wiid, Jon': '541-350-6994',
    'Welch, Bill': '458-218-2545',
    'Miller, Dustin': '458-218-2546',
    'Mooney, Tom': '541-362-6311',
    'Gibson, Wade': '541-948-7887',
    'Burch, Jodi': '503-551-8101',
    'Biondi, Shannon': '541-420-0860',
    'Jackson, Jessica': '541-788-2362',
    'Johannsen, TJ': '541-948-7888'
  };

  static final List<Contact> _items = _contactData.entries.map(
    (e) => Contact(name: e.key, number: e.value)
  ).toList();

  static Contact fetchAny() {
    return _items[0];
  }

  static List<Contact> fetchAll() {
    return _items;
  }
}
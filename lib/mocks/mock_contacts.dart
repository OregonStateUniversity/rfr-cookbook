import '../models/contact.dart';

mixin MockContact implements Contact {
  static const _contactData = {
    'Kehmna, Ken': '4582569440',
    'Puller, Jeff': '5414108149',
    'Cox, Diane': '5419795783',
    'Wood, Jon': '5413506994',
    'Welch, Bill': '4582182545',
    'Miller, Dustin': '4582182546',
    'Mooney, Tom': '5413626311',
    'Gibson, Wade': '5419487887',
    'Burch, Jodi': '5035518101',
    'Biondi, Shannon': '5414200860',
    'Jackson, Jessica': '5417882362',
    'Johannsen, TJ': '5419487888'
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
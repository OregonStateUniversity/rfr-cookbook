import 'package:flutter/material.dart';

void main() => runApp(const ProtocolApp());

class Protocol {
  final String title;

  Protocol(this.title);
}

class ProtocolApp extends StatefulWidget {
  const ProtocolApp({Key? key}) : super(key: key);

  @override
  _ProtocolAppState createState() => _ProtocolAppState();
}

class _ProtocolAppState extends State<ProtocolApp> {
  final ProtocolRouterDelegate _routerDelegate = ProtocolRouterDelegate();
  final ProtocolRouteInformationParser _routeInformationParser =
  ProtocolRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'The Cookbook',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class ProtocolRouteInformationParser extends RouteInformationParser<ProtocolRoutePath> {
  @override
  Future<ProtocolRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return ProtocolRoutePath.home();
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'protocol') return ProtocolRoutePath.unknown();

      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return ProtocolRoutePath.unknown();

      return ProtocolRoutePath.details(id);
    }

    return ProtocolRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(ProtocolRoutePath path) {
    if (path.isUnknown) {
      return const RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return const RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/protocol/${path.id}');
    }
    return null;
  }
}

class ProtocolRouterDelegate extends RouterDelegate<ProtocolRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ProtocolRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  Protocol? _selectedProtocol;
  bool show404 = false;

  List<Protocol> protocols = [
    Protocol('Preface'),
    Protocol('Operations'),
    Protocol('Procedures'),
    Protocol('Treatment'),
    Protocol('Medications'),
    Protocol('Trauma System'),
    Protocol('Hazardous Materials'),
  ];

  ProtocolRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  ProtocolRoutePath get currentConfiguration {
    if (show404) {
      return ProtocolRoutePath.unknown();
    }
    return _selectedProtocol == null
        ? ProtocolRoutePath.home()
        : ProtocolRoutePath.details(protocols.indexOf(_selectedProtocol!));
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('ProtocolListPage'),
          child: ProtocolListScreen(
            protocols: protocols,
            onTapped: _handleProtocolTapped,
          ),
        ),
        if (show404)
          const MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
        else if (_selectedProtocol != null)
          ProtocolDetailsPage(protocol: _selectedProtocol)
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _selectedProtocol = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(ProtocolRoutePath path) async {
    if (path.isUnknown) {
      _selectedProtocol = null;
      show404 = true;
      return;
    }

    if (path.isDetailsPage) {
      if (path.id! < 0 || path.id! > protocols.length - 1) {
        show404 = true;
        return;
      }

      _selectedProtocol = protocols[path.id!];
    } else {
      _selectedProtocol = null;
    }

    show404 = false;
  }

  void _handleProtocolTapped(Protocol protocol) {
    _selectedProtocol = protocol;
    notifyListeners();
  }
}

class ProtocolDetailsPage extends Page {
  final Protocol? protocol;

  ProtocolDetailsPage({
    this.protocol
  }) : super(key: ValueKey(protocol));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context){
        return ProtocolDetailsScreen(protocol: protocol!);
      },
    );
  }
}

class ProtocolRoutePath {
  final int? id;
  final bool isUnknown;

  ProtocolRoutePath.home()
      : id = null,
        isUnknown = false;

  ProtocolRoutePath.details(this.id)
      : isUnknown = false;

  ProtocolRoutePath.unknown()
      : id = null,
        isUnknown = true;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}

class ProtocolListScreen extends StatelessWidget {
  final List<Protocol> protocols;
  final ValueChanged<Protocol> onTapped;

  const ProtocolListScreen({Key? key,
    required this.protocols,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The Cookbook'),),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: protocols.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Center(child: Text(protocols[index].title)),
            onTap: () => onTapped(protocols[index]),
          );
        },
      ),
    );
  }
}

class ProtocolDetailsScreen extends StatelessWidget {
  final Protocol protocol;

  const ProtocolDetailsScreen({Key? key,
    required this.protocol
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(protocol.title),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // TODO: PDF file goes here
          ],
        ),
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('404!')),
        body: const Center(
          child: Text('404!'),
        )
    );
  }
}
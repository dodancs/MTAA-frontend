import 'package:CiliCat/components/AdoptionToggle.dart';
import 'package:CiliCat/components/AppTitleRefresh.dart';
import 'package:CiliCat/components/FilterDialog.dart';
import 'package:CiliCat/components/MainMenu.dart';
import 'package:CiliCat/components/OkDialog.dart';
import 'package:CiliCat/models/Breed.dart';
import 'package:CiliCat/models/Colour.dart';
import 'package:CiliCat/models/HealthStatus.dart';
import 'package:CiliCat/providers/SettingsProvider.dart';
import 'package:CiliCat/providers/StorageProvider.dart';
import 'package:CiliCat/screens/CatEditPage.dart';
import 'package:CiliCat/settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:CiliCat/components/CatCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/providers/CatsProvider.dart';

class HomePage extends StatefulWidget {
  static const screenRoute = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  bool canHaveMoreCats = true;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    canHaveMoreCats = true;
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      canHaveMoreCats =
          await Provider.of<CatsProvider>(context, listen: false).moreCats();
      print('More cats? ' + (canHaveMoreCats ? 'Yessss!!!' : 'No!'));
      setState(() {});
    }
  }

  Future<void> _refresh() async {
    _refreshKey.currentState?.show(atTop: false);
    await Provider.of<CatsProvider>(context, listen: false).getCats();
    setState(() {
      canHaveMoreCats = true;
    });
  }

  Future<void> _filterUpdate(Map<String, dynamic> settings,
      CatsProvider catsProvider, SettingsProvider settingsProvider) async {
    Breed b = settingsProvider.breedFrom(name: settings['breed']);
    Colour c = settingsProvider.colourFrom(name: settings['colour']);
    HealthStatus h =
        settingsProvider.healthStatusFrom(name: settings['health_status']);

    Map<String, dynamic> map = {
      'sex': settings['sex'] == null
          ? null
          : settings['sex'] == sexes[0] ? true : false,
      'breed': b == null ? null : b.id,
      'colour': c == null ? null : c.id,
      'health_status': h == null ? null : h.id,
      'vaccinated': settings['vaccinated'] == null
          ? null
          : settings['vaccinated'] == bools[0] ? false : true,
      'castrated': settings['castrated'] == null
          ? null
          : settings['castrated'] == bools[0] ? false : true,
      'dewormed': settings['dewormed'] == null
          ? null
          : settings['dewormed'] == bools[0] ? false : true,
      'age_up': settings['age_up'],
      'age_down': settings['age_down'],
    };

    await catsProvider.setFilter(map: map);

    print('Changing filters: ' + settings.toString());
  }

  @override
  Widget build(BuildContext context) {
    final storageProvider = Provider.of<StorageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final catsProvider = Provider.of<CatsProvider>(context);
    final cats = catsProvider.cats;
    final settingsProvider = Provider.of<SettingsProvider>(context);

    List<String> breeds = [
      ...settingsProvider.breeds.map((Breed b) {
        return b.name;
      }),
    ];

    List<String> colours = [
      ...settingsProvider.colours.map((Colour c) {
        return c.name;
      }),
    ];

    List<String> health_statuses = [
      ...settingsProvider.healthStatuses.map((HealthStatus h) {
        return h.name;
      }),
    ];

    if (cats.length == 0) {
      canHaveMoreCats = false;
    }

    return Scaffold(
      appBar: AppTitleRefresh(_refresh),
      drawer: MainMenu(),
      body: RefreshIndicator(
        key: _refreshKey,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: cats.length + 2,
          itemBuilder: (BuildContext context, int i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  children: <Widget>[
                    AdoptionToggle(
                      state: catsProvider.filter_adoptive,
                      callback: (state) {
                        if (storageProvider.connectivity ==
                            ConnectivityResult.none) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => OkDialog(
                                'Táto funkcionalita nie je podporovaná v režime offline!'),
                          );
                          setState(() {
                            catsProvider.filter_adoptive = true;
                          });
                          return;
                        }
                        Provider.of<CatsProvider>(context, listen: false)
                            .setFilter(filter: 'adoptive', value: state);
                      },
                    ),
                    Spacer(),
                    MaterialButton(
                      child: Text('FILTER'),
                      onPressed: () {
                        if (storageProvider.connectivity ==
                            ConnectivityResult.none) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => OkDialog(
                                'Táto funkcionalita nie je podporovaná v režime offline!'),
                          );
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => FilterDialog(
                            breeds: breeds,
                            colours: colours,
                            health_statuses: health_statuses,
                            currentSex: catsProvider.filter_sex == null
                                ? null
                                : catsProvider.filter_sex ? sexes[0] : sexes[1],
                            currentBreed: settingsProvider.breedFrom(
                                        id: catsProvider.filter_breed) !=
                                    null
                                ? settingsProvider
                                    .breedFrom(id: catsProvider.filter_breed)
                                    .name
                                : null,
                            currentColour: settingsProvider.colourFrom(
                                        id: catsProvider.filter_colour) !=
                                    null
                                ? settingsProvider
                                    .colourFrom(id: catsProvider.filter_colour)
                                    .name
                                : null,
                            currentHealthStatus: settingsProvider
                                        .healthStatusFrom(
                                            id: catsProvider
                                                .filter_health_status) !=
                                    null
                                ? settingsProvider
                                    .healthStatusFrom(
                                        id: catsProvider.filter_health_status)
                                    .name
                                : null,
                            currentVaccinated:
                                catsProvider.filter_vaccinated == null
                                    ? null
                                    : catsProvider.filter_vaccinated
                                        ? bools[1]
                                        : bools[0],
                            currentCastrated:
                                catsProvider.filter_castrated == null
                                    ? null
                                    : catsProvider.filter_castrated
                                        ? bools[1]
                                        : bools[0],
                            currentDewormed:
                                catsProvider.filter_dewormed == null
                                    ? null
                                    : catsProvider.filter_dewormed
                                        ? bools[1]
                                        : bools[0],
                            currentAge: RangeValues(
                                catsProvider.filter_age_down.toDouble(),
                                catsProvider.filter_age_up.toDouble()),
                            onUpdate: (Map<String, dynamic> map) {
                              this._filterUpdate(
                                  map, catsProvider, settingsProvider);
                            },
                          ),
                        );
                      },
                      color: palette,
                    )
                  ],
                ),
              );
            } else if (i == 1 && cats.length == 0) {
              return Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text('Žiadne výsledky'),
                ),
              );
            } else if (i > 0 && i <= cats.length) {
              return Container(
                child: CatCard(
                    cats[i - 1],
                    authProvider.getCurrentUser.favourites
                        .contains(cats[i - 1].uuid)),
              );
            }
            // Loading indicator
            if (i == cats.length + 1 && canHaveMoreCats) {
              return Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: SpinKitChasingDots(color: palette),
                ),
              );
            }

            return Container();
          },
        ),
        onRefresh: _refresh,
      ),
      floatingActionButton: authProvider.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                if (storageProvider.connectivity == ConnectivityResult.none) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => OkDialog(
                        'Táto funkcionalita nie je podporovaná v režime offline!'),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatEditPage(),
                  ),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: palette,
            )
          : null,
    );
  }
}

import 'package:CiliCat/components/AdoptionToggle.dart';
import 'package:CiliCat/components/AppTitle.dart';
import 'package:CiliCat/components/FilterDialog.dart';
import 'package:CiliCat/components/MainMenu.dart';
import 'package:CiliCat/settings.dart';
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
      // print('More cats? ' + (canHaveMoreCats ? 'Yessss!!!' : 'No!'));
      setState(() {});
    }
  }

  Future<Null> _refresh() async {
    _refreshKey.currentState?.show(atTop: false);
    await Provider.of<CatsProvider>(context, listen: false).getCats();
  }

  @override
  Widget build(BuildContext context) {
    final catsProvider = Provider.of<CatsProvider>(context);
    final cats = catsProvider.cats;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppTitle(),
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
                      state: true,
                      callback: (state) {
                        print('Current state is: $state');
                      },
                    ),
                    Spacer(),
                    MaterialButton(
                      child: Text('FILTER'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => FilterDialog(),
                        );
                      },
                      color: palette,
                    )
                  ],
                ),
              );
            } else if (i > 0 && i <= cats.length) {
              return Container(
                child: CatCard(cats[i - 1]),
              );
            }
            // Loading indicator
            if (i == cats.length + 1 && canHaveMoreCats) {
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: SpinKitChasingDots(color: palette),
                ),
              );
            }
          },
        ),
        onRefresh: _refresh,
      ),
      floatingActionButton: authProvider.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Icon(Icons.add),
              backgroundColor: palette,
            )
          : null,
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mucbirsebepler/bloc/databasebloc/bloc.dart';
import 'package:mucbirsebepler/model/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPage extends StatefulWidget {
  final User gelenUser;

  const ShopPage({Key key, this.gelenUser}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  DataBaseBloc _dataBaseBloc;
  bool isAvailable = true;
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription _subscription;
  SharedPreferences pref;
  bool isGmatik = false;
  bool isMatik = false;

  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("badges") == "isGmatik") {
        setState(() {
          isGmatik = true;
        });
      }
      if (prefs.getString("badges") == "isMatik") {
        setState(() {
          isMatik = true;
        });
      }
    });
  }

  @override
  void initState() {
    _dataBaseBloc = BlocProvider.of<DataBaseBloc>(context);
    _function();

    _initialize();
    _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
          _purchases.addAll(data);
          _verifyPurchase();
        }));
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ProgressDialog pr = ProgressDialog(context, isDismissible: false);
    pr.style(
        backgroundColor: Colors.lime,
        messageTextStyle: TextStyle(color: Colors.black),
        message: "Satın alım işlemi yapılıyor...",
        borderRadius: 30);

    return Scaffold(
      body: BlocListener(
        bloc: _dataBaseBloc,
        listener: (context, state) {
          if (state is DataBaseLoadingState) {
            pr.show();
          }
          if (state is DataBaseLoadedState) {
            pr.hide();
            FlareGiffyDialog(
              onlyOkButton: true,
              flarePath: 'assets/game.flr',
              flareAnimation: 'standby2',
              title: Text(
                '   Desteğin için  '
                'teşekkürler tospik',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              description: Text("Bizi unutmayacağız !"),
              entryAnimation: EntryAnimation.BOTTOM_LEFT,
              onOkButtonPressed: () {
                Navigator.of(context).pop();
              },
            );
          }
          if (state is DataBaseErrorState) {
            pr.hide();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Hata oluştu,Sonra tekrar deneyiniz..."),
              backgroundColor: Colors.redAccent,
            ));
          }
        },
        child: Container(
            color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100.0),
                    ),
                    child: Container(
                      color: Theme.of(context).accentColor,
                      width: width,
                      height: height / 7,
                      child: Align(
                          alignment: Alignment.center,
                          child: GradientText(
                            "Mücbir Mağaza",
                            gradient: LinearGradient(
                                colors: [Colors.pinkAccent, Colors.red]),
                            style: GoogleFonts.righteous(
                                fontSize:
                                    MediaQuery.of(context).size.height / 25),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(200, 300),
                      topRight: Radius.circular(80),
                      bottomRight: Radius.circular(150.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    child: Container(
                      height: height / 3.2,
                      color: Colors.pinkAccent,
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Align(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 85, top: 25),
                                      child: Text(
                                        "Gradient Tik",
                                        style: GoogleFonts.righteous(
                                            fontWeight: FontWeight.bold,
                                            fontSize: height / 50,
                                            letterSpacing: 1.5),
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 75, right: 10),
                                    child: Text(
                                      "Bartu ve Melikşah'a öncelikli olarak gözüküp hem de bize destek verebilirsin",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.normal,
                                        fontSize: height / 50,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, top: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.symmetric(
                                                    vertical: BorderSide(
                                                        color: Colors.cyan,
                                                        width: 4.0),
                                                    horizontal: BorderSide(
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        width: 4.0))),
                                            width: height / 10,
                                            height: height / 10,
                                            child: Image.asset(
                                              "assets/renkli.gif",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          RaisedButton(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            color: Colors.limeAccent,
                                            onPressed: () {
                                              _buyProduct(_products[1]);
                                            },
                                            child: Text(
                                              "Satın Al " +
                                                  _products[1].price +
                                                  " ₺",
                                              style: GoogleFonts.bangers(
                                                  fontSize: 19),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(200, 300),
                      topRight: Radius.circular(80),
                      bottomRight: Radius.circular(150.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    child: Container(
                      height: height / 3.5,
                      color: Colors.cyanAccent,
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Align(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 85, top: 20),
                                      child: Text(
                                        "MaTik",
                                        style: GoogleFonts.righteous(
                                            fontWeight: FontWeight.bold,
                                            fontSize: height / 50,
                                            letterSpacing: 1.5),
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 72, right: 10),
                                    child: Text(
                                      "Yeter artık Instagram! MATİK'li olmak artık çok kolay",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.normal,
                                        fontSize: height / 50,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, top: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.symmetric(
                                                    vertical: BorderSide(
                                                        color: Colors.cyan,
                                                        width: 4.0),
                                                    horizontal: BorderSide(
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        width: 4.0))),
                                            width: height / 10,
                                            height: height / 10,
                                            child: Image.asset(
                                              "assets/renksiz.gif",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          RaisedButton(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            color: Colors.limeAccent,
                                            onPressed: () {
                                              _buyProduct(_products[2]);
                                            },
                                            child: Text(
                                              "Satın Al " +
                                                  _products[2].price +
                                                  " ₺",
                                              style: GoogleFonts.bangers(
                                                  fontSize: 19),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(200, 300),
                      topRight: Radius.circular(80),
                      bottomRight: Radius.circular(150.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    child: Container(
                      height: height / 3.5,
                      color: Colors.orangeAccent,
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Align(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 90, top: 10),
                                      child: Text(
                                        "Destekçi Rozeti",
                                        style: GoogleFonts.righteous(
                                            fontWeight: FontWeight.bold,
                                            fontSize: height / 45,
                                            letterSpacing: 1.5),
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 88, right: 10),
                                    child: Text(
                                      "Destekçi rozetine sahip olup hem de bana kahve ısmarlayabilirsiniz<3",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.normal,
                                        fontSize: height / 50,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, top: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.symmetric(
                                                    vertical: BorderSide(
                                                        color: Colors.cyan,
                                                        width: 4.0),
                                                    horizontal: BorderSide(
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        width: 4.0))),
                                            width: height / 10,
                                            height: height / 10,
                                            child: Image.asset(
                                              "assets/icon/destek.png",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          RaisedButton(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            color: Colors.limeAccent,
                                            onPressed: () {
                                              _buyProduct(_products[0]);
                                            },
                                            child: Text(
                                              "Satın Al " +
                                                  _products[0].price +
                                                  " ₺",
                                              style: GoogleFonts.bangers(
                                                  fontSize: 19),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(200, 300),
                      topRight: Radius.circular(80),
                      bottomRight: Radius.circular(150.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                    child: Container(
                      height: height / 3.5,
                      color: Colors.redAccent,
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Align(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 88, top: 10),
                                      child: Text(
                                        "Ürün Yerleştirmecisi",
                                        style: GoogleFonts.righteous(
                                            fontWeight: FontWeight.bold,
                                            fontSize: height / 45,
                                            letterSpacing: 1.5),
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 83, right: 10),
                                    child: Text(
                                      "Yerleştirme rozetine sahip olup hem de ürün yerleştirebilirsiniz <3",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.normal,
                                        fontSize: height / 50,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, top: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.symmetric(
                                                    vertical: BorderSide(
                                                        color: Colors.cyan,
                                                        width: 4.0),
                                                    horizontal: BorderSide(
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        width: 4.0))),
                                            width: height / 10,
                                            height: height / 10,
                                            child: Image.asset(
                                              "assets/icon/yerles.png",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          RaisedButton(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            color: Colors.limeAccent,
                                            onPressed: () {
                                              _buyProduct(_products[3]);
                                            },
                                            child: Text(
                                              "Satın Al " +
                                                  _products[3].price +
                                                  " ₺",
                                              style: GoogleFonts.bangers(
                                                  fontSize: 19),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void _initialize() async {
    isAvailable = await _iap.isAvailable();
    if (isAvailable) {
      debugPrint("evet");
      await _getProducts();
      await _getPastPurchases();
    } else
      debugPrint("hayır");
  }

  Future<void> _getProducts() async {
    Set<String> ids = <String>[
      'gradient_tikk',
      'mavi_tikk',
      'destek_badgee',
      'urun_yerlestirmee'
    ].toSet();
    ProductDetailsResponse productDetailsResponse =
        await _iap.queryProductDetails(ids);

    setState(() {
      _products = productDetailsResponse.productDetails;
      debugPrint(_products.toString());
    });
  }

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse queryPurchaseDetailsResponse =
        await _iap.queryPastPurchases();
    for (PurchaseDetails purchase
        in queryPurchaseDetailsResponse.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    setState(() {
      _purchases = queryPurchaseDetailsResponse.pastPurchases;
    });
  }

  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased('gradient_tikk');
    PurchaseDetails purchase2 = _hasPurchased('mavi_tikk');
    PurchaseDetails purchase3 = _hasPurchased('destek_badgee');
    PurchaseDetails purchase4 = _hasPurchased('urun_yerlestirmee');

    // TODO serverside verification & record consumable in the database

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      if (!isGmatik) {
        _dataBaseBloc.add(BecomeBadge(
            userID: widget.gelenUser.userID, whichBadge: "isGmatik"));
        sharedKaydet("isGmatik");
      }
    }
    if (purchase2 != null && purchase2.status == PurchaseStatus.purchased) {
      if (!isMatik) {
        _dataBaseBloc.add(BecomeBadge(
            userID: widget.gelenUser.userID, whichBadge: "isMatik"));
        sharedKaydet("isMatik");
      }
    }
    if (purchase3 != null && purchase3.status == PurchaseStatus.purchased) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            "Destekçi olduğunuz için çok çok teşekkür ederim. Badge'in en kısa zamanda hesabına yüklenecek"),
      ));
    }
    if (purchase4 != null && purchase4.status == PurchaseStatus.purchased) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            "Ürün yerleştirme için lütfen sekspirdev@gmail.com mail adresime ayrıntıları belirtiniz"),
        duration: Duration(milliseconds: 1000),
      ));
    }
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> sharedKaydet(String badgeNames) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.setString("badges", badgeNames);
  }
}

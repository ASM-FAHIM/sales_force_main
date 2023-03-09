import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper{
  DBHelper.internal();
  static final DBHelper dbHelper = DBHelper.internal();
  factory DBHelper() => dbHelper;
  static  const loginTable = 'loginTable';
  static  const loginStatus = 'loginStatus';
  static  const territoryTable = 'territoryTable';
  static  const tsoInfoTable = 'tsoInfoTable';
  static  const dealerTable = 'dealerTable';
  static  const productTable = 'productTable';
  static  const caCusPrice = 'caCusPrice';
  static  const cartTable = 'cartTable';
  static  const cartDetailsTable = 'cartDetailsTable';
  static  const giftAndPromotion = 'giftAndPromotion';
  static  const workNoteTable = 'workNote';
  static  const dealerVisitTable = 'dealerVisitTable';
  static final _version = 1;
  static Database? _db;

  Future<Database?> get db async {
    if (_db !=null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path,'salesforce.db');
    print(dbPath);
    var openDb = await openDatabase(dbPath,version: _version,
        onCreate: (Database db,int version) async{
          await db.execute("""
        CREATE TABLE $loginTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          xname VARCHAR(150), 
          xstaff VARCHAR(150), 
          xdeptname VARCHAR(150), 
          xposition VARCHAR(150), 
          zemail VARCHAR(150),
          xpassword VARCHAR(150),
          xdesignation VARCHAR(150),
          xsid VARCHAR(150),
          xempbank VARCHAR(150),
          xacc VARCHAR(150),
          xsex VARCHAR(150),
          xempcategory VARCHAR(150),
          supname VARCHAR(150),
          xrole VARCHAR(150)
          )""");
          await db.execute("""
        CREATE TABLE $loginStatus (
          loginStatus TEXT 
          )""");
          await db.execute("""
        CREATE TABLE $territoryTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          zid VARCHAR(150),
          xterritory VARCHAR(150),
          xsp VARCHAR(150), 
          xso VARCHAR(150)
          )""");
          await db.execute("""
        CREATE TABLE $tsoInfoTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          zid INTEGER,
          xwh VARCHAR(150),
          xsp VARCHAR(150), 
          xstaff VARCHAR(150), 
          xsm VARCHAR(150), 
          xrsm VARCHAR(150), 
          xname VARCHAR(150), 
          xphone VARCHAR(150), 
          xterritory VARCHAR(150),
          mTarget VARCHAR(150),
          dTarget VARCHAR(150),
          mshopvisit VARCHAR(150)
          )""");
          await db.execute("""
        CREATE TABLE $dealerTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          zid INTEGER ,
          xso VARCHAR(150), 
          xcus VARCHAR(150), 
          xorg VARCHAR(150), 
          xmadd VARCHAR(150), 
          xterritory VARCHAR(150),
          xfield VARCHAR(150),
          xphone VARCHAR(150),
          xgcus VARCHAR(150),
          xdateeff VARCHAR(150),
          xdateexp VARCHAR(150)
          )""");
          await db.execute("""
        CREATE TABLE $productTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          xitem VARCHAR(150), 
          xdesc VARCHAR(150), 
          xrate VARCHAR(150), 
          xvatrate VARCHAR(150), 
          xvatamt VARCHAR(150),
          xminrate VARCHAR(150),
          totrate VARCHAR(150), 
          dealrate VARCHAR(150), 
          xgitem VARCHAR(150), 
          xpackqty VARCHAR(150), 
          xunitsel VARCHAR(150),
          xdisc VARCHAR(150),
          xdiscstatus VARCHAR(150),
          xunitiss VARCHAR(150),
          xdealerp VARCHAR(150),
          xpsize VARCHAR(150),
          xtheircode VARCHAR(150),
          xsubcat VARCHAR(150)
          )""");
          await db.execute("""
        CREATE TABLE $caCusPrice (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          xrow VARCHAR(150), 
          xcus VARCHAR(150), 
          xitem VARCHAR(150), 
          xrate VARCHAR(150), 
          xcost VARCHAR(150),
          xdateeff VARCHAR(150),
          xdateexp VARCHAR(150)
          )""");
          await db.execute("""
        CREATE TABLE $cartTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          zid INTEGER,
          xwh VARCHAR(150),
          cartID VARCHAR(150),
          xso VARCHAR(150), 
          xcus VARCHAR(150),
          xorg VARCHAR(150),
          xterritory VARCHAR(150),
          xareaop VARCHAR(150),
          xdivision VARCHAR(150),
          xsubcat VARCHAR(150),
          xdelivershift VARCHAR(150),
          total REAL,
          lattitude VARCHAR(150),
          longitude VARCHAR(150),
          xstatus VARCHAR(150),
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
          )""");
          await db.execute("""
        CREATE TABLE $cartDetailsTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          zid INTEGER,
          cartID VARCHAR(150) NOT NULL,          
          xitem VARCHAR(150),          
          xdesc VARCHAR(150),
          xunit VARCHAR(150),
          xrate REAL,
          xqty REAL,
          subTotal REAL,
          FOREIGN KEY (cartID) REFERENCES $cartTable(cartID)
          )""");
          await db.execute("""
        CREATE TABLE $giftAndPromotion (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type VARCHAR(150),          
          xitem VARCHAR(150),          
          itemName VARCHAR(150),
          xwh VARCHAR(150),
          xgiftitem VARCHAR(150),
          giftName VARCHAR(150),
          xqty VARCHAR(150),
          xqty1 VARCHAR(150),
          xqty2 VARCHAR(150),
          xqty3 VARCHAR(150),
          xqty4 VARCHAR(150),
          xqtybonus VARCHAR(150),
          xqtybonus1 VARCHAR(150),
          xqtybonus2 VARCHAR(150),
          xqtybonus3 VARCHAR(150),
          xqtybonus4 VARCHAR(150)
          )""");
          await db.execute("""
        CREATE TABLE $workNoteTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,     
          tsoId VARCHAR(150),          
          note VARCHAR(150),         
          subtitle VARCHAR(150),         
          createdAt VARCHAR(150)
          )""");
          await db.execute("""
        CREATE TABLE $dealerVisitTable (
          id INTEGER PRIMARY KEY,
          tsoId VARCHAR(150),
          dealerName VARCHAR(150),   
          xidsup VARCHAR(150),       
          xdate VARCHAR(150),         
          InTime VARCHAR(150),
          Latitude VARCHAR(150),
          Longitude VARCHAR(150),
          location VARCHAR(150),
          ImagePath VARCHAR(150)
          )""");
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Upgrade");
          }
        }
    );
    return openDb;
  }

}
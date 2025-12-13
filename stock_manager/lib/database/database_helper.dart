// Assurez-vous d'ajouter dans pubspec.yaml :
// dependencies:
//   sqflite: ^2.0.0+4
//   path: ^1.8.0
//   uuid: ^3.0.0
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_manager/models/product.dart';
import 'package:stock_manager/models/sale.dart';
import 'package:stock_manager/models/stock_movement.dart';
import 'package:stock_manager/models/category.dart';
import 'package:uuid/uuid.dart';

/// Helper de gestion de la base de données SQLite
class DatabaseHelper {
  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // --- Connexion & Initialisation ---
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('stock_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        parentId TEXT,
        description TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        barcode TEXT NOT NULL,
        categoryId TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        minQuantity INTEGER NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE stock_movements (
        id TEXT PRIMARY KEY,
        productId TEXT NOT NULL,
        productName TEXT NOT NULL,
        quantityChange INTEGER NOT NULL,
        type TEXT NOT NULL,
        reason TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE sales (
        id TEXT PRIMARY KEY,
        productId TEXT NOT NULL,
        productName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unitPrice REAL NOT NULL,
        totalPrice REAL NOT NULL,
        customerName TEXT NOT NULL,
        customerPhone TEXT,
        notes TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
    // Données de démonstration
    await _insertDemoData(db);
  }

  Future<void> _insertDemoData(Database db) async {
    final uuid = const Uuid();
    final now = DateTime.now();

    // Insert demo categories
    final electronicsId = uuid.v4();
    final shoesId = uuid.v4();
    final clothingId = uuid.v4();

    await db.insert('categories', {
      'id': electronicsId,
      'name': 'Électronique',
      'parentId': null,
      'description': 'Produits électroniques',
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    });

    await db.insert('categories', {
      'id': shoesId,
      'name': 'Chaussures',
      'parentId': null,
      'description': 'Chaussures et accessoires',
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    });

    await db.insert('categories', {
      'id': clothingId,
      'name': 'Vêtements',
      'parentId': null,
      'description': 'Vêtements et accessoires',
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    });

    final demoProducts = [
      {
        'id': uuid.v4(),
        'name': 'iPhone 15 Pro',
        'barcode': '1234567890123',
        'categoryId': electronicsId,
        'price': 1199.99,
        'quantity': 15,
        'minQuantity': 5,
        'description': 'Smartphone Apple dernière génération',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      },
      {
        'id': uuid.v4(),
        'name': 'Samsung Galaxy S24',
        'barcode': '2234567890123',
        'categoryId': electronicsId,
        'price': 999.99,
        'quantity': 3,
        'minQuantity': 5,
        'description': 'Smartphone Samsung flagship',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      },
      {
        'id': uuid.v4(),
        'name': 'Nike Air Max',
        'barcode': '3234567890123',
        'categoryId': shoesId,
        'price': 149.99,
        'quantity': 25,
        'minQuantity': 10,
        'description': 'Chaussures de sport Nike',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      },
      {
        'id': uuid.v4(),
        'name': 'Adidas Ultraboost',
        'barcode': '4234567890123',
        'categoryId': shoesId,
        'price': 179.99,
        'quantity': 8,
        'minQuantity': 10,
        'description': 'Chaussures running Adidas',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      },
      {
        'id': uuid.v4(),
        'name': 'T-Shirt Lacoste',
        'barcode': '5234567890123',
        'categoryId': clothingId,
        'price': 59.99,
        'quantity': 50,
        'minQuantity': 20,
        'description': 'T-shirt polo Lacoste',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      },
      {
        'id': uuid.v4(),
        'name': 'Jean Levi\'s 501',
        'barcode': '6234567890123',
        'categoryId': clothingId,
        'price': 89.99,
        'quantity': 2,
        'minQuantity': 15,
        'description': 'Jean classique Levi\'s',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      },
      {
        'id': uuid.v4(),
        'name': 'MacBook Pro 14"',
        'barcode': '7234567890123',
        'categoryId': electronicsId,
        'price': 2399.99,
        'quantity': 5,
        'minQuantity': 3,
        'description': 'Ordinateur portable Apple M3',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      },
      {
        'id': uuid.v4(),
        'name': 'AirPods Pro 2',
        'barcode': '8234567890123',
        'categoryId': electronicsId,
        'price': 279.99,
        'quantity': 20,
        'minQuantity': 10,
        'description': 'Écouteurs sans fil Apple',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      },
    ];

    for (var product in demoProducts) {
      await db.insert('products', product);
    }
    // Utilisateur de démonstration
    await db.insert('users', {
      'id': uuid.v4(),
      'email': 'demo@stockmanager.com',
      'password': 'demo123',
      'name': 'Utilisateur Demo',
      'createdAt': now.toIso8601String(),
    });
  }

  // --- Section Produits ---

  /// Crée un produit
  Future<String> createProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toMap());
    return product.id;
  }

  /// Insère un produit
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  /// Retourne tous les produits
  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final result = await db.query('products', orderBy: 'name ASC');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  /// Retourne un produit par id
  Future<Product?> getProduct(String id) async {
    final db = await database;
    final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Product.fromMap(result.first);
  }

  /// Met à jour un produit
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  /// Supprime un produit
  Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  /// Recherche de produits par nom ou code-barres
  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final result = await db.query(
      'products',
      where: 'name LIKE ? OR barcode LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((map) => Product.fromMap(map)).toList();
  }

  /// Retourne les produits d'une catégorie
  Future<List<Product>> getProductsByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );
    return result.map((map) => Product.fromMap(map)).toList();
  }

  /// Retourne les produits en stock faible
  Future<List<Product>> getLowStockProducts() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT * FROM products WHERE quantity <= minQuantity ORDER BY quantity ASC',
    );
    return result.map((map) => Product.fromMap(map)).toList();
  }

  /// Retourne la liste des catégories
  Future<List<Category>> getCategories() async {
    final db = await database;
    final result = await db.query('categories', orderBy: 'name ASC');
    return result.map((map) => Category.fromMap(map)).toList();
  }

  // --- Section Mouvements de stock ---

  /// Crée un mouvement de stock
  Future<void> createStockMovement(StockMovement movement) async {
    final db = await database;
    await db.insert('stock_movements', movement.toMap());
  }

  /// Retourne les derniers mouvements de stock
  Future<List<StockMovement>> getStockMovements({int limit = 50}) async {
    final db = await database;
    final result = await db.query(
      'stock_movements',
      orderBy: 'createdAt DESC',
      limit: limit,
    );
    return result.map((map) => StockMovement.fromMap(map)).toList();
  }

  /// Retourne les mouvements d'un produit
  Future<List<StockMovement>> getProductMovements(String productId) async {
    final db = await database;
    final result = await db.query(
      'stock_movements',
      where: 'productId = ?',
      whereArgs: [productId],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => StockMovement.fromMap(map)).toList();
  }

  // --- Section Utilisateurs ---

  /// Authentifie un utilisateur
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isEmpty) return null;
    return result.first;
  }

  /// Inscrit un nouvel utilisateur
  Future<void> registerUser(String email, String password, String name) async {
    final db = await database;
    final uuid = const Uuid();
    await db.insert('users', {
      'id': uuid.v4(),
      'email': email,
      'password': password,
      'name': name,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // --- Section Ventes ---

  /// Crée une vente
  Future<String> createSale(Sale sale) async {
    final db = await database;
    await db.insert('sales', sale.toMap());
    return sale.id;
  }

  /// Retourne toutes les ventes
  Future<List<Sale>> getAllSales() async {
    final db = await database;
    final result = await db.query('sales', orderBy: 'createdAt DESC');
    return result.map((map) => Sale.fromMap(map)).toList();
  }

  /// Retourne une vente par id
  Future<Sale?> getSale(String id) async {
    final db = await database;
    final result = await db.query('sales', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Sale.fromMap(result.first);
  }

  /// Met à jour une vente
  Future<int> updateSale(Sale sale) async {
    final db = await database;
    return await db.update(
      'sales',
      sale.toMap(),
      where: 'id = ?',
      whereArgs: [sale.id],
    );
  }

  /// Supprime une vente
  Future<int> deleteSale(String id) async {
    final db = await database;
    return await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  /// Recherche de ventes par client ou produit
  Future<List<Sale>> searchSales(String query) async {
    final db = await database;
    final result = await db.query(
      'sales',
      where: 'customerName LIKE ? OR productName LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => Sale.fromMap(map)).toList();
  }

  /// Ferme la connexion à la base
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

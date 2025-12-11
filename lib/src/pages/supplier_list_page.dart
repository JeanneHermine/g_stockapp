import 'package:flutter/material.dart';
import 'package:mon_premier_projet/models/supplier.dart';

class SupplierListPage extends StatelessWidget {
  final List<Supplier> suppliers;
  const SupplierListPage({super.key, required this.suppliers});

  @override
  Widget build(BuildContext context) {
    return _SupplierListPageContent(suppliers: suppliers);
  }
}

class _SupplierListPageContent extends StatefulWidget {
  final List<Supplier> suppliers;
  const _SupplierListPageContent({required this.suppliers});

  @override
  State<_SupplierListPageContent> createState() =>
      _SupplierListPageContentState();
}

class _SupplierListPageContentState extends State<_SupplierListPageContent> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {

    import 'package:flutter/material.dart';
    import '../../models/supplier.dart';
    import '../../services/localization_service.dart';
      import '../../services/barcode_service.dart';
        import '../../services/audit_service.dart';
          import '../../services/push_notification_service.dart';
            import '../../services/theme_service.dart';
              import '../../services/offline_sync_service.dart';
                OfflineSyncService offlineSyncService = OfflineSyncService();
              ThemeService themeService = ThemeService();
            PushNotificationService pushNotificationService = PushNotificationService();
          AuditService auditService = AuditService();
        BarcodeService barcodeService = BarcodeService();
      LocalizationService localizationService = LocalizationService();
    import '../../services/alert_service.dart';

    class SupplierListPage extends StatefulWidget {
      @override
      _SupplierListPageState createState() => _SupplierListPageState();
    }

      List<Supplier> suppliers = [];
      AlertService alertService = AlertService();
      ExportService exportService = ExportService();

      @override
      void initState() {
        super.initState();
        // TODO: Charger les fournisseurs depuis le backend
        _checkAlerts();
      }

      void _checkAlerts() {
        // Exemple d'alerte automatique (à adapter selon la logique métier)
        if (suppliers.isEmpty) {
          alertService.showAlert(context, 'Aucun fournisseur enregistré.');
        }
        // TODO: Ajouter d'autres alertes (stock bas, expiration, etc.)
      }

      void _addSupplier() {
        showDialog(
          context: context,
          builder: (context) {
            String name = '';
            String contact = '';
            return AlertDialog(
              title: Text('Ajouter un fournisseur'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nom'),
                    onChanged: (value) => name = value,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Contact'),
                    onChanged: (value) => contact = value,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      suppliers.add(Supplier(name: name, contact: contact));
                      _checkAlerts();
                      auditService.logAction('Ajout fournisseur', 'Nom: $name, Contact: $contact');
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Ajouter'),
                ),
              ],
            );
          },
        );
      }

      void _editSupplier(int index) {
        showDialog(
          context: context,
          builder: (context) {
            String name = suppliers[index].name;
            String contact = suppliers[index].contact;
            return AlertDialog(
              title: Text('Modifier le fournisseur'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nom'),
                    controller: TextEditingController(text: name),
                    onChanged: (value) => name = value,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Contact'),
                    controller: TextEditingController(text: contact),
                    onChanged: (value) => contact = value,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      suppliers[index] = Supplier(name: name, contact: contact);
                      auditService.logAction('Modification fournisseur', 'Nom: $name, Contact: $contact');
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      }

      void _deleteSupplier(int index) {
        setState(() {
          auditService.logAction('Suppression fournisseur', 'Nom: ${suppliers[index].name}, Contact: ${suppliers[index].contact}');
          suppliers.removeAt(index);
        });
      }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizationService.translate('suppliers')),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addSupplier,
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            tooltip: 'Test notification',
            onPressed: () async {
              await pushNotificationService.sendTestNotification('Test notification', 'Ceci est un test de notification push.');
              alertService.showAlert(context, 'Notification push envoyée');
            },
          ),
          IconButton(
            icon: Icon(Icons.receipt_long),
            tooltip: 'Factures',
            onPressed: () {
              Navigator.pushNamed(context, '/invoices');
            },
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final result = await barcodeService.scanBarcode(context);
              if (result != null && result.isNotEmpty) {
                alertService.showAlert(context, 'Code scanné: ' + result);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.location_on),
            tooltip: 'Emplacements',
            onPressed: () {
              Navigator.pushNamed(context, '/locations');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pdf') {
                exportService.exportSuppliersToPDF(suppliers);
              } else if (value == 'excel') {
                exportService.exportSuppliersToExcel(suppliers);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pdf',
                child: Text(localizationService.translate('export_pdf')),
              ),
              PopupMenuItem(
                value: 'excel',
                child: Text(localizationService.translate('export_excel')),
              ),
            ],
            icon: Icon(Icons.download),
          ),
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              setState(() {
                localizationService.toggleLanguage();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.color_lens),
            tooltip: 'Changer le thème',
            onPressed: () {
              setState(() {
                themeService.toggleTheme(context);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.sync),
            tooltip: 'Synchroniser hors-ligne',
            onPressed: () async {
              await offlineSyncService.syncSuppliers(suppliers);
              alertService.showAlert(context, 'Synchronisation hors-ligne effectuée');
            },
          ),
          IconButton(
            icon: Icon(Icons.confirmation_number),
            tooltip: 'Lots & numéros de série',
            onPressed: () {
              Navigator.pushNamed(context, '/batches');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          final supplier = suppliers[index];
          return ListTile(
            title: Text(supplier.name),
            subtitle: Text(supplier.contact),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editSupplier(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteSupplier(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
                // Modification logique métier ici
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteSupplierDialog(BuildContext context, Supplier supplier) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le fournisseur'),
          content: Text('Voulez-vous vraiment supprimer ${supplier.name} ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Suppression logique métier ici
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}

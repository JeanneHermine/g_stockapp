
# Stock ManagerTODO

1.Graphiques Interactifs
[ ] Ajouter des gestionnaires de clic aux sections du graphique circulaire dans statistics_screen.dart pour afficher des ventilations détaillées (par exemple, la liste des produits pour une catégorie).

[ ] Ajouter des gestionnaires de clic aux barres du graphique à barres pour afficher les détails du produit.

[ ] Ajouter des info-bulles (tooltips) ou des boîtes de dialogue pour des informations détaillées au clic.

2.Constructeur de Rapports Personnalisés
[ ] Créer un nouvel écran : lib/screens/report_builder_screen.dart.

[ ] Implémenter une interface de glisser-déposer pour la sélection des champs (nom du produit, quantité, prix, etc.).

[ ] Ajouter des filtres (plage de dates, catégorie, etc.).

[ ] Générer et afficher les rapports personnalisés.

3.Cartes Thermiques (Heat Maps)
[ ] Ajouter un widget de carte thermique à statistics_screen.dart en utilisant fl_chart ou un nouveau package.

[ ] Visualiser les données de ventes par heure/jour et par emplacement (si disponible, ou catégorie comme substitut).

[ ] Coder l'intensité par couleur en fonction du volume des ventes.

4.Indicateurs de Tendance
[ ] Ajouter la logique de calcul de tendance (comparer la période actuelle à la période précédente).

[ ] Ajouter des flèches/icônes aux graphiques et aux cartes de statistiques montrant les tendances à la hausse/à la baisse.

[ ] Mettre à jour statistics_screen.dart avec des indicateurs de tendance.

5.Exportation au format PDF/Excel
[ ] Ajouter les dépendances pdf et excel à pubspec.yaml.

[ ] Étendre export_helper.dart pour prendre en charge l'exportation PDF avec formatage.

[ ] Étendre export_helper.dart pour prendre en charge l'exportation Excel avec formatage.

[ ] Ajouter des boutons d'exportation aux écrans de statistiques et de construction de rapports.

Persistance des Données et Améliorations de l'Interface Utilisateur
[x] Ajouter des mouvements de stock et des ventes de démonstration à database_helper.dart pour peupler les données initiales.

[x] Mettre à jour history_screen.dart pour utiliser des couleurs neutres (par exemple, des tons de gris) au lieu du vert/rouge vif.

[x] Mettre à jour sales_screen.dart pour supprimer le dégradé vert et utiliser des couleurs neutres pour la carte de résumé et les icônes.

[x] Mettre à jour le thème de main.dart pour utiliser une couleur de base (seed color) plus neutre (par exemple, bleu-gris) pour un look professionnel.

[x] Tester l'application pour s'assurer qu'il n'y a pas d'erreurs et que les données persistent après les redémarrages.

Général
[ ] Mettre à jour pubspec.yaml avec les nouvelles dépendances si nécessaire.

[ ] Tester toutes les implémentations pour s'assurer qu'il n'y a pas d'erreurs dans les fichiers existants.

[ ] S'assurer que tout nouveau code s'intègre parfaitement sans casser les fonctionnalités existantes,

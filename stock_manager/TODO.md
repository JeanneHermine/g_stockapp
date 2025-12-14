# TODO: Implement Five Basic Functionalities

## 1. Interactive Charts
- [ ] Add click handlers to pie chart sections in statistics_screen.dart to show detailed breakdowns (e.g., product list for category)
- [ ] Add click handlers to bar chart bars to show product details
- [ ] Add tooltips or dialogs for detailed info on click

## 2. Custom Report Builder
- [ ] Create new screen: lib/screens/report_builder_screen.dart
- [ ] Implement drag-and-drop interface for selecting fields (product name, quantity, price, etc.)
- [ ] Add filters (date range, category, etc.)
- [ ] Generate and display custom reports

## 3. Heat Maps
- [ ] Add heat map widget to statistics_screen.dart using fl_chart or new package
- [ ] Visualize sales data by time (hour/day) and location (if available, or category as proxy)
- [ ] Color-code intensity based on sales volume

## 4. Trend Indicators
- [ ] Add trend calculation logic (compare current vs previous period)
- [ ] Add arrow/icons to charts and stats cards showing up/down trends
- [ ] Update statistics_screen.dart with trend indicators

## 5. Export to PDF/Excel
- [ ] Add pdf and excel dependencies to pubspec.yaml
- [ ] Extend export_helper.dart to support PDF export with formatting
- [ ] Extend export_helper.dart to support Excel export with formatting
- [ ] Add export buttons to statistics and report builder screens

## General
- [ ] Update pubspec.yaml with new dependencies if needed
- [ ] Test all implementations to ensure no errors in existing files
- [ ] Ensure all new code integrates seamlessly without breaking existing functionality

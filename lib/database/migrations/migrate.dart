import 'create_customers_table.dart';
import 'create_vendors_table.dart';
import 'create_products_table.dart';
import 'create_orders_table.dart';
import 'create_orderitems_table.dart';
import 'create_productnotes_table.dart';
import 'create_users_table.dart';


Future<void> runMigrations() async {
  print('Migrating customers table...');
  await createCustomersTable();

  print('Migrating vendors table...');
  await createVendorsTable();

  print('Migrating products table...');
  await createProductsTable();

  print('Migrating orders table...');
  await createOrdersTable();

  print('Migrating orderitems table...');
  await createOrderItemsTable();

  print('Migrating productnotes table...');
  await createProductNotesTable();

  print('Migrating users table...');
  await createUsersTable();

  print('Migrations completed successfully.');
}

void main() async {
  await runMigrations();
}

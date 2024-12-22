import 'package:shelf_router/shelf_router.dart';
import '../app/http/controllers/customers_controller.dart';
import '../app/http/controllers/orders_controller.dart';
import '../app/http/controllers/orderitems_controller.dart';
import '../app/http/controllers/vendors_controller.dart';
import '../app/http/controllers/products_controller.dart';
import '../app/http/controllers/productnotes_controller.dart';
import '../app/http/controllers/auth_controller.dart';


Router apiRouter() {
  final router = Router();

  // Customers
  router.get('/customers', CustomersController.getAll);
  router.post('/customers', CustomersController.create);
  router.put('/customers/<id>', CustomersController.update);
  router.delete('/customers/<id>', CustomersController.delete);

  // Orders
  router.get('/orders', OrdersController.getAll);
  router.post('/orders', OrdersController.create);
  router.put('/orders/<id>', OrdersController.update);
  router.delete('/orders/<id>', OrdersController.delete);

  // OrderItems
  router.get('/orderitems', OrderItemsController.getAll);
  router.post('/orderitems', OrderItemsController.create);
  router.put('/orderitems/<id>', OrderItemsController.update);
  router.delete('/orderitems/<id>', OrderItemsController.delete);

  // Vendors
  router.get('/vendors', VendorsController.getAll);
  router.post('/vendors', VendorsController.create);
  router.put('/vendors/<id>', VendorsController.update);
  router.delete('/vendors/<id>', VendorsController.delete);

  // Products
  router.get('/products', ProductsController.getAll);
  router.post('/products', ProductsController.create);
  router.put('/products/<id>', ProductsController.update);
  router.delete('/products/<id>', ProductsController.delete);

  // ProductNotes
  router.get('/productnotes', ProductNotesController.getAll);
  router.post('/productnotes', ProductNotesController.create);
  router.put('/productnotes/<id>', ProductNotesController.update);
  router.delete('/productnotes/<id>', ProductNotesController.delete);

  //auth
  router.post('/register', AuthController.register);
  router.post('/login', AuthController.login);

  return router;
}

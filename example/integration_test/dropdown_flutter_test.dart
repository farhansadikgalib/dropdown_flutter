import 'package:integration_test/integration_test.dart';

import '../../test/dropdown_flutter_test.dart' as dropdown;
import '../../test/list_item_height_test.dart' as row_height;
import '../../test/listener_lifecycle_test.dart' as lifecycle;
import '../../test/regressions_test.dart' as regressions;
import '../../test/ux_test.dart' as ux;
import '../test/gallery_test.dart' as gallery;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  dropdown.main();
  row_height.main();
  lifecycle.main();
  regressions.main();
  ux.main();
  gallery.main();
}

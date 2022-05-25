// ignore_for_file: library_prefixes

import 'flavors.dart' as Flav;
import 'main.dart';

Future<void> buildFlavors(Flav.Flavor flavor) async {
  Flav.F.appFlavor = flavor;
  main();
}

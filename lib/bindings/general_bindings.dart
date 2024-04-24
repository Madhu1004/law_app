import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:law_app/reusable_widgets/reusable_widgets.dart';

class GeneralBindings extends Bindings{

  @override
  void dependencies(){
    Get.put(NetworkManager());
  }
}
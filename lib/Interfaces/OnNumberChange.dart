import 'package:event_bus/event_bus.dart';
EventBus eventBusNC = EventBus();
class OnNumberChange{

  String mobile;
  String code;

  OnNumberChange(this.mobile,this.code);
}
import 'package:event_bus/event_bus.dart';
EventBus eventBusHTC = EventBus();
class OnHomeTabChange{

  String tabName;

  OnHomeTabChange(this.tabName);
}
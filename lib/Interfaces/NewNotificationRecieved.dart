import 'package:event_bus/event_bus.dart';
EventBus eventBusN = EventBus();
class NewNotificationRecieved{

  String count;

  NewNotificationRecieved(this.count);
}
import 'package:event_bus/event_bus.dart';
EventBus eventBusDL = EventBus();
class OnDeepLinkContent{

  int key;
  String type;

  OnDeepLinkContent(this.key,this.type);
}
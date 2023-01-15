part of 'product_bloc.dart';

enum Event { start, updateLatest, getAll, clearAll, updated, removeSelected }

abstract class ProductEvent extends Equatable {
  const ProductEvent({required this.event});
  final Event event;

  @override
  List<Object> get props => [];
}

class EventStart extends ProductEvent {
  const EventStart() : super(event: Event.start);
}

class EventUpdateLatest extends ProductEvent {
  const EventUpdateLatest() : super(event: Event.updateLatest);
}

class EventGetAll extends ProductEvent {
  const EventGetAll() : super(event: Event.getAll);
}

class EventClearAll extends ProductEvent {
  const EventClearAll() : super(event: Event.clearAll);
}

class EventUpdated extends ProductEvent {
  const EventUpdated({required this.list}) : super(event: Event.updated);
  final List<Product> list;
}

class EventRemoveSelected extends ProductEvent {
  const EventRemoveSelected({required this.list})
      : super(event: Event.removeSelected);
  final List<Product> list;
}




extension IterableExtensions<T> on Iterable<T>{

  T? get firstOrNull {
    if (isEmpty){
      return null;
    } else {
      return first;
    }
  }

  Iterable<T> intersperse(T element, Iterable<T> iterable) sync* {
    final iterator = iterable.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield element;
        yield iterator.current;
      }
    }
  }

}



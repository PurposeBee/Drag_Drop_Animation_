extension ReplacementExtension<T> on List<T> {
  List<T> addOrReplace(T item) {
    final i = indexOf(item);
    if (i != -1) {
      this[i] = item;
      return this;
    } else {
      add(item);
      return this;
    }
  }

  List<T> addOrRemove(T item) {
    if (contains(item)) {
      remove(item);
      return this;
    } else {
      add(item);
      return this;
    }
  }

  List<T> addRemove(T item) {
    if (contains(item)) {
      remove(item);
      return this;
    } else {
      clear();
      add(item);
      return this;
    }
  }
}

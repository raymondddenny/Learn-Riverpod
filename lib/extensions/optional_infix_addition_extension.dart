/// This extension is to [check] if the left value is null or not,
/// if it is null then return null, otherwise return the addition of the left and right values.
extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

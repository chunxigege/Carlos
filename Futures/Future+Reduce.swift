extension SequenceType where Generator.Element: Async {
  /**
  Reduces a sequence of Future`<T>` into a single Future`<U>` through a closure that takes a value T and the current accumulated value of the previous iterations (starting from initialValue) and returns a value of type U
   
  - parameter initialValue: The initial value for the reduction of this sequence
  - parameter combine: The closure used to reduce the sequence
   
  - returns: a new Future`<U>` that will succeed when all the Future`<T>` of this array will succeed, with a value obtained through the execution of the combine closure on each result of the original Futures. The result will fail or get canceled if one of the original futures fail or get canceled
  */
  public func reduce<U>(initialValue: U, combine: (accumulator: U, value: Generator.Element.Value) -> U) -> Future<U> {
    return reduce(Promise(value: initialValue).future, combine: { accumulator, value in
      accumulator.flatMap { reduced in
        value.future.map { mapped in
          combine(accumulator: reduced, value: mapped)
        }
      }
    })
  }
}
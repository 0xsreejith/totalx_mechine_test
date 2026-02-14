/// Base use case abstraction.
/// Simplified to return T or throw Failure for this implementation.
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

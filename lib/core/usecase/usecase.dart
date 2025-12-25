abstract class Usecase<Type, Args> {
  Future<Type> call(Args params);
}

class NoArgs {}

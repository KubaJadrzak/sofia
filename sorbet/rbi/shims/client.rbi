# typed: strict

module Sofia
  class Client
    extend T::Sig

    sig { params(block: T.nilable(T.proc.params(req: Request).returns(T.untyped))).returns(Response) }
    def get(&block); end

    sig { params(block: T.nilable(T.proc.params(req: Request).returns(T.untyped))).returns(Response) }
    def post(&block); end

    sig { params(block: T.nilable(T.proc.params(req: Request).returns(T.untyped))).returns(Response) }
    def put(&block); end

    sig { params(block: T.nilable(T.proc.params(req: Request).returns(T.untyped))).returns(Response) }
    def patch(&block); end

    sig { params(block: T.nilable(T.proc.params(req: Request).returns(T.untyped))).returns(Response) }
    def delete(&block); end
  end
end
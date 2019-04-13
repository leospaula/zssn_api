module Error
  class TradeError < StandardError
    attr_reader :status, :message

    def initialize(_status=nil, _message=nil)
      @status = _status || :unprocessable_entity
      @message = _message || 'Something went wrong'
    end
  end
end
module Sessions
  module ProcessWraper
    def for(**args)
      self.new(**args).process
    end
  end
end

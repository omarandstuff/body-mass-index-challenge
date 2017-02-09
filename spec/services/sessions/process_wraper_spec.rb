require 'rails_helper'

describe Sessions::ProcessWraper do
  let(:dummy_service) { Class.new { extend Sessions::ProcessWraper
                                    def initialize(**args)end
                                    define_method(:process) { "process_executed"} }}

  describe '.for' do
    it 'returns the result of the instance method process' do
      trivial_arguments = { arg1: 1, arg2: 2 }
      result = dummy_service.for **trivial_arguments

      expect(result).to eq "process_executed"
    end
  end
end

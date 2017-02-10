require 'rails_helper'

describe Sessions::ProcessWraper do
  let(:dummy_service) do 
    Class.new do
      extend Sessions::ProcessWraper
      
      def initialize(a,b)
      end
      
      define_method(:process) { "process_executed" } 
    end
  end

  describe '.for' do
    it 'returns the result of the instance method process' do
      result = dummy_service.for(1,2)

      expect(result).to eq "process_executed"
    end
  end
end

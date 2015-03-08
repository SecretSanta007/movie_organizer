require 'spec_helper'

module MovieOrganizer
  RSpec.describe Logger, type: :lib do

    let(:buffer)         { StringIO.new }
    let(:default_logger) { ::Logger.new(buffer) }
    let(:logger)         { Logger.send(:new, default_logger) }
    let(:data)           { { key: 'value' } }

    context '.log_exception' do
      it 'logs a formatted exception' do
        exception = StandardError.new('bogus')
        exception.set_backtrace(caller)
        expect(buffer.string).to be_empty
        logger.log_exception(exception, data)
        expect(buffer.string).to match(/StandardError\s+:\s+bogus/)
      end
    end

    context '.method_missing' do
      it 'does not call bad_method' do
        expect { logger.bogus }.to raise_error(NoMethodError)
      end
    end

    context '.respond_to?' do
      it 'does not respond to bad_method' do
        expect(logger.respond_to?(:bad_method)).to eq(false)
      end
    end

  end
end

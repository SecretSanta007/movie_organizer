module MovieOrganizer
  RSpec.describe Organizer, type: :lib do
    let(:organizer) { Organizer.instance }

    context '#instance' do
      it "calls 'initialize'" do
        expect(Organizer).to receive(:new)
        organizer
      end

      it 'instantiates the logger' do
        organizer.logger
      end
    end

    context '.start' do
      it 'logs' do
        expect(organizer.logger).to receive(:info)
        organizer.start
      end
    end
  end
end

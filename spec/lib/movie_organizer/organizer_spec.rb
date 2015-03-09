module MovieOrganizer
  RSpec.describe Organizer, type: :lib do
    include_context 'media_shared'

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
      let(:args) do
        {
          source_dir: tmpdir, help: false, source_dir_given: true
        }
      end

      before do
        create_test_file(filename: 'Beetlejuice', extension: 'mp4')
      end

      it 'does something' do
        expect(organizer).to receive(:collect_args).and_return(args)
        organizer.start
      end
    end
  end
end

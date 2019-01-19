require 'elplano'

describe Elplano do
  let(:root_path) { Pathname.new(File.expand_path('../..', __dir__)) }

  describe '.root' do
    it { expect(described_class.root).to eq(root_path) }
  end

  describe '.revision' do
    around do |example|
      described_class.instance_variable_set(:@_revision, nil)
      example.run
      described_class.instance_variable_set(:@_revision, nil)
    end

    context 'when a REVISION file exists' do
      before do
        revision_path = root_path.join('REVISION')

        allow(File).to receive(:exist?).with(revision_path).and_return(true)
        allow(File).to receive(:read).with(revision_path).and_return("wat#rev12\n")
      end

      it 'returns the actual application revision' do
        expect(described_class.revision).to eq('wat#rev12')
      end

      it 'memorizes the revision' do
        expect(File).to receive(:read)
                          .once
                          .with(root_path.join('REVISION'))
                          .and_return("wat#rev12\n")

        2.times { described_class.revision }
      end
    end

    context 'when no REVISION file exist' do
      it { expect(described_class.revision).to eq('Unknown') }
    end
  end
end

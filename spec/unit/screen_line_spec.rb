require 'spec_helper'

module TSM
  describe ScreenLine do
    let(:line) { ScreenLine.new }

    describe '#<<' do
      it 'appends new cell' do
        expect(line.size).to eq(0)

        line << []
        expect(line.size).to eq(1)

        line << []
        expect(line.size).to eq(2)
      end
    end

    describe '#[]' do
      before do
        line << 'a'
        line << 'b'
        line << 'c'
      end

      specify do
        expect(line[2]).to eq('c')
        expect(line[1]).to eq('b')
        expect(line[0]).to eq('a')
        expect(line[3]).to be(nil)
      end
    end

    describe '#to_s' do
      subject { line.to_s }

      before do
        line << [nil, 'x']
        line << [nil, 'y']
        line << [nil, 'z']
      end

      it { should eq('xyz') }
    end
  end
end

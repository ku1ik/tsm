require 'spec_helper'

module TSM
  describe ScreenSnapshot do
    let(:snapshot) { ScreenSnapshot.new }

    describe '#<<' do
      it 'appends new line' do
        expect(snapshot.size).to eq(0)

        snapshot << ScreenLine.new
        expect(snapshot.size).to eq(1)

        snapshot << ScreenLine.new
        expect(snapshot.size).to eq(2)
      end
    end

    describe '#[]' do
      before do
        snapshot << 'a'
        snapshot << 'b'
        snapshot << 'c'
      end

      specify do
        expect(snapshot[2]).to eq('c')
        expect(snapshot[1]).to eq('b')
        expect(snapshot[0]).to eq('a')
        expect(snapshot[3]).to be(nil)
      end
    end

    describe '#to_s' do
      subject { snapshot.to_s }

      before do
        snapshot << 'foo '
        snapshot << 'bar '
        snapshot << 'baz '
      end

      it { should eq("foo \nbar \nbaz ") }
    end
  end
end

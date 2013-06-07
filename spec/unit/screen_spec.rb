require 'spec_helper'

module TSM
  describe Screen do
    let(:screen) { Screen.new(20, 10) }

    describe '#cursor_x' do
      subject { screen.cursor_x }

      it { should eq(0) }
    end

    describe '#cursor_y' do
      subject { screen.cursor_y }

      it { should eq(0) }
    end

    describe '#cursor_visible?' do
      subject { screen.cursor_visible? }

      it { should be(true) }
    end

    describe '#snapshot' do
      let(:snapshot) { screen.snapshot }

      it 'has dimensions of the screen' do
        expect(snapshot.size).to eq(10)
        expect(snapshot[0].size).to eq(20)
      end

      it 'containts cells with attribute and char' do
        attr, char = snapshot[0][0]
        expect(attr).to be_kind_of(ScreenAttribute)
        expect(char).to eq('')
      end
    end
  end
end

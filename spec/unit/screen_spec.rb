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
  end
end

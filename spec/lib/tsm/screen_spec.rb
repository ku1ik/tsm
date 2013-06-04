require 'spec_helper'

module TSM
  describe Screen do
    let(:screen) { Screen.new(20, 10) }

    describe '#width' do
      subject { screen.width }

      it { should eq(20) }
    end

    describe '#height' do
      subject { screen.height }

      it { should eq(10) }
    end

    describe '#resize' do
      before do
        screen.resize(80, 24)
      end

      it 'changes width and height' do
        expect(screen.width).to eq(80)
        expect(screen.height).to eq(24)
      end
    end

    describe '#cursor_x' do
      subject { screen.cursor_x }

      it { should eq(0) }
    end

    describe '#cursor_y' do
      subject { screen.cursor_y }

      it { should eq(0) }
    end

    describe '#move_cursor_left' do
      before do
        screen.move_cursor_right(4)
      end

      context "when number given" do
        before do
          screen.move_cursor_left(3)
        end

        it 'changes cursor_x' do
          expect(screen.cursor_x).to eq(1)
        end
      end

      context "when no number given" do
        before do
          screen.move_cursor_left
        end

        it 'changes cursor_x' do
          expect(screen.cursor_x).to eq(3)
        end
      end
    end

    describe '#move_cursor_right' do
      context "when number given" do
        before do
          screen.move_cursor_right(3)
        end

        it 'changes cursor_x' do
          expect(screen.cursor_x).to eq(3)
        end
      end

      context "when no number given" do
        before do
          screen.move_cursor_right
        end

        it 'changes cursor_x' do
          expect(screen.cursor_x).to eq(1)
        end
      end
    end

    describe '#flags' do
      subject { screen.flags }

      it { should be_kind_of(Fixnum) }
    end

    describe '#flags=' do
      let(:new_flags) { Screen::FLAG_HIDE_CURSOR }

      before do
        screen.flags = new_flags
      end

      it 'changes flags' do
        expect(screen.flags).to eq(new_flags)
      end
    end

    describe '#cursor_visible?' do
      subject { screen.cursor_visible? }

      it { should be(true) }

      context "when flags include FLAG_HIDE_CURSOR" do
        before do
          screen.flags = Screen::FLAG_HIDE_CURSOR
        end

        it { should be(false) }
      end
    end

    describe '#draw' do
      let(:out) { [] }

      before do
        screen.draw do |x, y, char, attr|
          out[y] ||= []
          out[y][x] = [char, attr]
        end
      end

      it 'draws all lines' do
        expect(out.compact.size).to eq(10)
      end

      it 'draws all columns' do
        expect(out[0].compact.size).to eq(20)
      end

      it 'draws a character with the text attributes' do
        cell = out[0][0]
        expect(cell.first).to be_kind_of(String)
        expect(cell.last).to be_kind_of(ScreenAttribute)
      end
    end
  end
end

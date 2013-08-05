require 'spec_helper'

module TSM
  describe 'Feeding Vte' do
    def color_snapshot(screen)
      lines = []

      screen.draw do |x, y, char, attr|
        line = lines[y] ||= []
        line[x] = [char, attr]
      end

      lines
    end

    def snapshot(screen)
      snapshot = ''
      line_no = 0

      screen.draw do |x, y, char, attr|
        if y != line_no
          line_no = y
          snapshot << "\n"
        end

        snapshot << char
      end

      snapshot
    end

    let(:screen) { Screen.new(10, 3) }
    let(:vte) { Vte.new(screen) }
    let(:output) { snapshot(screen) }
    let(:color_output) { color_snapshot(screen) }

    describe 'with a string' do
      specify do
        vte.input("foo bar")

        expect(output[0..6]).to eq("foo bar")
        expect(screen.cursor_x).to eq(7)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with an array' do
      specify do
        vte.input([102, 111, 111])

        expect(output[0..2]).to eq("foo")
        expect(screen.cursor_x).to eq(3)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with a string ... and then again' do
      specify do
        vte.input("foo bar")
        vte.input("baz")

        expect(output[0..9]).to eq("foo barbaz")
        expect(screen.cursor_x).to eq(10)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with the carriage return' do
      specify do
        vte.input("foo\rbar")

        expect(output[0..2]).to eq("bar")
        expect(screen.cursor_x).to eq(3)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with the new line character' do
      specify do
        vte.input("foo\nbar")

        expect(output[0..16]).to eq("foo       \n   bar")
        expect(screen.cursor_x).to eq(6)
        expect(screen.cursor_y).to eq(1)
      end
    end

    describe 'with hard space' do
      specify do
        pending "TODO: check with kmscon guys why doesn't it work like it should"

        vte.input("+\xa0+")

        expect(output[0..2]).to eq("+ +")
        expect(screen.cursor_x).to eq(3)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with a text longer than screen width' do
      specify do
        vte.input("abcdefghijklmnopqrs")

        expect(output.lines.take(2)).to eq(["abcdefghij\n", "klmnopqrs \n"])
        expect(screen.cursor_x).to eq(9)
        expect(screen.cursor_y).to eq(1)
      end
    end

    describe 'with a sophisticated unicode character' do
      specify do
        vte.input("foo\xe2\x94\x8cbar")

        expect(output.lines.first).to eq("foo┌bar   \n")
        expect(screen.cursor_x).to eq(7)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with a 256-color mode foreground color' do
      subject { color_output[0][0][1][:fg] }

      before do
        vte.input("\x1b[38;5;#{color_code}mX")
      end

      (1..255).each do |n|
        context "of value #{n}" do
          let(:color_code) { n }

          it { should eq(n) }
        end
      end
    end

    describe 'with a 256-color mode background color' do
      subject { color_output[0][0][1][:bg] }

      before do
        vte.input("\x1b[48;5;#{color_code}mX")
      end

      (1..255).each do |n|
        context "of value #{n}" do
          let(:color_code) { n }

          it { should eq(n) }
        end
      end
    end
  end
end

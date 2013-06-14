require 'spec_helper'

module TSM
  describe 'Feeding Vte' do
    let(:screen) { Screen.new(10, 3) }
    let(:vte) { Vte.new(screen) }
    let(:snapshot) { screen.snapshot }
    let(:output) { snapshot.to_s }

    describe 'with just a text' do
      specify do
        vte.input("foo bar")

        expect(output[0..6]).to eq("foo bar")
        expect(screen.cursor_x).to eq(7)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with just a text.. and the again' do
      specify do
        vte.input("foo bar")
        vte.input("baz")

        expect(output[0..9]).to eq("foo barbaz")
        expect(screen.cursor_x).to eq(10)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with carriage return' do
      specify do
        vte.input("foo\rbar")

        expect(output[0..2]).to eq("bar")
        expect(screen.cursor_x).to eq(3)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with new line character' do
      specify do
        vte.input("foo\nbar")

        expect(output[0..16]).to eq("foo       \n   bar")
        expect(screen.cursor_x).to eq(6)
        expect(screen.cursor_y).to eq(1)
      end
    end

    describe 'with hard space' do
      specify do
        pending 'TODO: check with kmscon guys why does it work like it should'

        vte.input("+\xa0+")

        expect(output[0..2]).to eq("+ +")
        expect(screen.cursor_x).to eq(3)
        expect(screen.cursor_y).to eq(0)
      end
    end

    describe 'with text longer than screen width' do
      specify do
        vte.input("abcdefghijklmnopqrs")

        expect(output.lines.take(2)).to eq(["abcdefghij\n", "klmnopqrs \n"])
        expect(screen.cursor_x).to eq(9)
        expect(screen.cursor_y).to eq(1)
      end
    end

    describe 'with sophisticated unicode character' do
      specify do
        vte.input("foo\xe2\x94\x8cbar")

        expect(output.lines.first).to eq("foo┌bar   \n")
        expect(screen.cursor_x).to eq(7)
        expect(screen.cursor_y).to eq(0)
      end
    end
  end
end

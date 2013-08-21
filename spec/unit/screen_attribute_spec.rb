require 'spec_helper'

module TSM

  describe ScreenAttribute do
    let(:struct) { ScreenAttributeStruct.new }

    describe '#to_screen_attribute' do
      let(:attribute) { struct.to_screen_attribute }

      describe 'fg' do
        subject { attribute.fg }

        before do
          struct[:fccode] = 5
        end

        it { should eq(5) }
      end

      describe 'bg' do
        subject { attribute.bg }

        before do
          struct[:bccode] = 7
        end

        it { should eq(7) }
      end

      describe 'bold?' do
        subject { attribute.bold? }

        context "when first bit is not set" do
          before do
            struct[:flags] = 2 # second only
          end

          it { should be(false) }
        end

        context "when first bit is set" do
          before do
            struct[:flags] = 1 # first only
          end

          it { should be(true) }
        end
      end

      describe 'underline?' do
        subject { attribute.underline? }

        context "when second bit is not set" do
          before do
            struct[:flags] = 1 # first only
          end

          it { should be(false) }
        end

        context "when second bit is set" do
          before do
            struct[:flags] = 3 # first + second
          end

          it { should be(true) }
        end
      end

      describe 'inverse?' do
        subject { attribute.inverse? }

        context "when third bit is not set" do
          before do
            struct[:flags] = 8 # fourth only
          end

          it { should be(false) }
        end

        context "when third bit is set" do
          before do
            struct[:flags] = 6 # second + third
          end

          it { should be(true) }
        end
      end

      describe 'blink?' do
        subject { attribute.blink? }

        context "when fifth bit is not set" do
          before do
            struct[:flags] = 15 # first four
          end

          it { should be(false) }
        end

        context "when fifth bit is set" do
          before do
            struct[:flags] = 17 # first + fifth
          end

          it { should be(true) }
        end
      end
    end
  end

end

require 'spec_helper'

module TSM

  describe ScreenAttribute do
    let(:attribute) { ScreenAttribute.new }
    let(:struct) { { :fccode => 1, :bccode => 2, :flags => 5} }

    describe '#to_h' do

      subject(:hash) do
        struct.each do |name, value|
          attribute[name] = value
        end

        attribute.to_h
      end

      it { should eq({ :fg => 1, :bg => 2, :bold => true, :underline => false,
                       :inverse => true, :blink => false }) }

      describe ':fg' do
        subject { hash[:fg] }

        before do
          struct[:fccode] = 5
        end

        it { should eq(5) }
      end

      describe ':bg' do
        subject { hash[:bg] }

        before do
          struct[:bccode] = 7
        end

        it { should eq(7) }
      end

      describe ':bold' do
        subject { hash[:bold] }

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

      describe ':underline' do
        subject { hash[:underline] }

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

      describe ':inverse' do
        subject { hash[:inverse] }

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

      describe ':blink' do
        subject { hash[:blink] }

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

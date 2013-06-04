require 'spec_helper'

module TSM
  describe ScreenAttribute do
    let(:attribute) { ScreenAttribute.new }

    describe '#fg' do
      subject { attribute.fg }

      before do
        attribute[:fccode] = 5
      end

      it { should eq(5) }
    end

    describe '#bg' do
      subject { attribute.bg }

      before do
        attribute[:bccode] = 7
      end

      it { should eq(7) }
    end

    describe '#bold?' do
      subject { attribute.bold? }

      context "when first bit is not set" do
        before do
          attribute[:flags] = 2 # second only
        end

        it { should be(false) }
      end

      context "when first bit is set" do
        before do
          attribute[:flags] = 1 # first only
        end

        it { should be(true) }
      end
    end

    describe '#underline?' do
      subject { attribute.underline? }

      context "when second bit is not set" do
        before do
          attribute[:flags] = 1 # first only
        end

        it { should be(false) }
      end

      context "when second bit is set" do
        before do
          attribute[:flags] = 3 # first + second
        end

        it { should be(true) }
      end
    end

    describe '#inverse?' do
      subject { attribute.inverse? }

      context "when third bit is not set" do
        before do
          attribute[:flags] = 8 # fourth only
        end

        it { should be(false) }
      end

      context "when third bit is set" do
        before do
          attribute[:flags] = 6 # second + third
        end

        it { should be(true) }
      end
    end

    describe '#as_json' do
      subject { attribute.as_json }

      before do
        attribute[:fccode] = 1
        attribute[:bccode] = 2
        attribute[:flags]  = 5
      end

      it { should eq({ :fg        => 1,
                       :bg        => 2,
                       :bold      => true,
                       :underline => false,
                       :inverse   => true }) }
    end

    describe '#==' do
      let(:attr_1) { ScreenAttribute.new }
      let(:attr_2) { ScreenAttribute.new }
      let(:attr_3) { ScreenAttribute.new }
      let(:attr_4) { ScreenAttribute.new }

      before do
        attr_1[:fccode] = 1
        attr_1[:bccode] = 2
        attr_1[:flags]  = 3

        attr_2[:fccode] = 1
        attr_2[:bccode] = 2
        attr_2[:flags]  = 3

        attr_3[:fccode] = 0
        attr_3[:bccode] = 2
        attr_3[:flags]  = 3

        attr_4[:fccode] = 0
        attr_4[:bccode] = 2
        attr_4[:flags]  = 3
      end

      specify { expect(attr_1).to eq(attr_2) }
      specify { expect(attr_2).to_not eq(attr_3) }
      specify { expect(attr_3).to eq(attr_4) }
      specify { expect(attr_4).to_not eq(attr_1) }
    end
  end
end

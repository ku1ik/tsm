require 'spec_helper'

module TSM
  describe ScreenAttributeStruct do
    it 'acts like a hash with the proper keys' do
      expect(subject[:fccode]).to be_kind_of(Fixnum)
      expect(subject[:bccode]).to be_kind_of(Fixnum)
      expect(subject[:flags]).to be_kind_of(Fixnum)
    end
  end

  describe ScreenAttribute do
    let(:attribute) { ScreenAttribute.new(struct) }
    let(:struct) { {} }

    describe '#fg' do
      subject { attribute.fg }

      before do
        struct[:fccode] = 5
      end

      it { should eq(5) }
    end

    describe '#bg' do
      subject { attribute.bg }

      before do
        struct[:bccode] = 7
      end

      it { should eq(7) }
    end

    describe '#bold?' do
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

    describe '#underline?' do
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

    describe '#inverse?' do
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

    describe '#as_json' do
      subject { attribute.as_json }

      before do
        struct[:fccode] = 1
        struct[:bccode] = 2
        struct[:flags]  = 5
      end

      it { should eq({ :fg        => 1,
                       :bg        => 2,
                       :bold      => true,
                       :underline => false,
                       :inverse   => true }) }
    end

    describe '#==' do
      let(:attr_1)   { ScreenAttribute.new(struct_1) }
      let(:attr_2)   { ScreenAttribute.new(struct_2) }
      let(:attr_3)   { ScreenAttribute.new(struct_3) }
      let(:attr_4)   { ScreenAttribute.new(struct_4) }
      let(:struct_1) { {} }
      let(:struct_2) { {} }
      let(:struct_3) { {} }
      let(:struct_4) { {} }

      before do
        struct_1[:fccode] = 1
        struct_1[:bccode] = 2
        struct_1[:flags]  = 3

        struct_2[:fccode] = 1
        struct_2[:bccode] = 2
        struct_2[:flags]  = 3

        struct_3[:fccode] = 0
        struct_3[:bccode] = 2
        struct_3[:flags]  = 3

        struct_4[:fccode] = 0
        struct_4[:bccode] = 2
        struct_4[:flags]  = 3
      end

      specify { expect(attr_1).to eq(attr_2) }
      specify { expect(attr_2).to_not eq(attr_3) }
      specify { expect(attr_3).to eq(attr_4) }
      specify { expect(attr_4).to_not eq(attr_1) }
    end
  end
end

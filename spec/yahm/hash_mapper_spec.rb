require_relative "../spec_helper"

describe Yahm::HashMapper do
  context "when extending a class" do
    let(:class_extended_with_hash_mapper) do
      class MyClass
        extend Yahm::HashMapper
      end
    end

    it "adds a class method called #define_mapper" do
      expect(class_extended_with_hash_mapper.methods).to include(:define_mapper)
    end
  end

  describe "#define_mapper" do
    let(:class_extended_with_hash_mapper) do
      class ClassExtendedWithHashMapper
        extend Yahm::HashMapper

        define_mapper :my_mapper do
        end
      end
    end

    it "adds a named mapper method to the instances of the extended class" do
      expect(class_extended_with_hash_mapper.new).to respond_to(:my_mapper)
    end

    context "when called with an option called 'call_setter'" do
      let(:class_extended_with_hash_mapper) do
        class ClassExtendedWithHashMapper
          extend Yahm::HashMapper

          attr_accessor :my_result

          define_mapper :my_mapper, call_setter: :my_result= do
          end
        end
      end

      it "calls a method with the given name with the result of the mapping" do
        (instance = class_extended_with_hash_mapper.new).my_mapper({})
        expect(instance.my_result).not_to be_nil
      end
    end
  end
end

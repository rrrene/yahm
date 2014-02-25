require_relative "../spec_helper"

describe Yahm::Mapping do
  it "is a class used internally by Yahm::HashMapper#define_mapper" do
  end

  describe ".map" do
    let(:mapping) { Yahm::Mapping.new }

    it "adds a mapping rule to a mapping" do
      mapping.map("/foo", to: "bar")
      expect(mapping.instance_variable_get :@rules).not_to be_nil
    end
  end
  
  describe ".translate_hash" do
    let(:mapping) do
      _mapping = Yahm::Mapping.new
      _mapping.map "/record_id",        to: "/id"
      _mapping.map "/record/title",     to: "/tile"
      _mapping.map "/record/isbns",     to: "/my_data/isbns"
      _mapping.map "/record/isbns[1]",  to: "/main_isbn"                     # when an array, one can specifiy which element to choose
      _mapping.map "/record/count",     to: "/count", :processed_by => :to_i # processed_by specifies a method which post_processes to value
      _mapping.map "/record/languages", to: "/languages", force_array: true
      _mapping.map "/record/authors",   to: "/authors", split_by: ";"
      _mapping.map "/record/version",   to: "/version", default: 1
      _mapping
    end

    let(:input_hash) do
      {
        record_id: "some_id123",
        record: {
          title: "some title",
          isbns: [
            "3-86680-192-0",
            "3-680-08783-7"
          ],
          count: "3",
          languages: "ger",
          authors: "John Doe; Jane Doe"
        }
      }
    end

    it "translates a given hash according to @rules" do
      expect(mapping.translate_hash(input_hash)).to eq({
        :id=>"some_id123",
        :tile=>"some title",
        :my_data=>{:isbns=>["3-86680-192-0", "3-680-08783-7"]},
        :main_isbn=>"3-680-08783-7",
        :count=>3,
        :languages=>["ger"],
        :authors=>["John Doe", "Jane Doe"],
        :version=>1
      })
    end
  end

end

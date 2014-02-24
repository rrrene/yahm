module Yahm::HashMapper
  def define_mapper(mapper_method_name, options = {}, &block)
    mapping = Yahm::Mapping.new

    # evaluate the given block in mappings context
    mapping = mapping.instance_eval(&block) || mapping

    define_method mapper_method_name do |hash|
      translated_hash = mapping.translate_hash(hash)
      unless (setter_name = options[:call_setter]).nil?
        self.send(setter_name, translated_hash)
      end

      translated_hash
    end

    self
  end
end

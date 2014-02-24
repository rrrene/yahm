class Yahm::Mapping
  def initialize
    @rules = []
    @translated_hash = nil
  end

  def map(str, options = {})
    @rules.push [str, options]
    self
  end

  def translate_hash(input_hash)
    @break = true if @rules.length == 5
    @translated_hash = {}

    @rules.each do |rule|
      process_rule(input_hash, rule)
    end

    @translated_hash
  end

  private

  def process_rule(input_hash, rule)
    sanitized_source_path = rule.first
    .sub(/^\//, "")
    .gsub(/\[(\d+)\]/, "/\\1")
    .split("/")
    .map do |element|
      if element[/\A\d+\Z/]
        element.to_i
      else
        element.to_sym
      end
    end

    sanitized_target_path = rule.last[:to].sub(/^\//, "").split("/").map(&:to_sym)
    target_parent_path = sanitized_target_path.slice(0, sanitized_target_path.length - 1)

    source_value = sanitized_source_path.inject(input_hash) { |hash, key| hash[key] }

    unless (processed_by_method_name = rule.last[:processed_by]).nil?
      source_value = if source_value.is_a?(Array)
        source_value.map(&processed_by_method_name)
      else
        source_value.send(processed_by_method_name)
      end
    end

    target_hash_parent_element = target_parent_path.inject(@translated_hash) { |hash, key| hash[key.to_sym] ||= {} }
    target_hash_parent_element.merge!({ sanitized_target_path.last => source_value })
  end
end

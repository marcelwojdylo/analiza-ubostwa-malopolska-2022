# frozen_string_literal: true

class Object
  def present?
    return true if nil?

    case self
    when String
      return true unless self == ''
    when Array
      return true unless self == []
    when Hash
      return true unless self == {}
    end
    false
  end
end

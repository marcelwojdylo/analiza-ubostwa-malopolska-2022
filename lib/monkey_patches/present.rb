# frozen_string_literal: true

class Object
  def present?
    return true if self == nil
    if self.is_a? String
      return true unless self == ''
    elsif self.is_a? Array
      return true unless self == []
    elsif self.is_a? Hash
      return true unless self == {}
    end
    false
  end
end

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def error_codes
    errors.group_by_attribute.transform_values { |err| err.map(&:type) }
  end
end

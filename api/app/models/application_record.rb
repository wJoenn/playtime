class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def error_codes
    errors.group_by_attribute.each do |_attribute, errors|
      errors.map! do |error|
        case error.type
        when :other_than then :"#{error.type}_#{error.options[:count]}"
        else error.type
        end
      end
    end
  end
end

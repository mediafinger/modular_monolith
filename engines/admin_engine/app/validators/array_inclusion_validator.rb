# from: https://github.com/sciencehistory/kithe/blob/master/app/validators/array_inclusion_validator.rb
# and slightly refactored
#
# Like the default Rails inclusion validator, but the built-in Rails
# validator won't work on an _array_ of things.
#
# So if you have an array of primitive values, you can use this to
# validate that all elements of the array are in the inclusion list.
#
# Or that all the elements of the array are whatever you want,
# by supplying a proc that returns false for bad values.
#
# Empty arrays are always allowed, add a presence validator if you don't
# want to allow them, eg `validates :genre, presence: true, array_inclusion: { in: whatever }`
#
# @example
#    class Work < Kithe::Work
#      attr_json :genre, :string, array: true
#      validates :genre, array_inclusion: { in: ALLOWED_GENRES  }
#      validates :genre, array_inclusion: { proc: ->(val) { val =~ /\d+/ } }
#      #...
#
# Custom message can interpolate `rejected_values` value. (Should also work for i18n)
#
# Note: There isn't currently a great way to show primitive array validation errors on
# a form for an invalid edit, the validation error can only be shown as if for the entire
# array field, not the individual invalid edit. You might consider modelling as a compound
# Model with only one attribute instead of as a primitive.
#
# @example
#   validates :genre, array_inclusion: { in: ALLOWED_GENRES, message: "option %{rejected_values} not allowed"  }
#   validates :genre, array_inclusion: { proc: ->(v) { v =~ /horror/ }, message: "%{rejected_values} do not include horror" }
#
class ArrayInclusionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    values = Array(value) || []
    rejected = []

    rejected.concat(values - options[:in]) if options[:in]
    rejected.concat(values.find_all { |v| !options[:proc].call(v) }) if options[:proc]

    return if rejected.blank?

    formatted_rejected = rejected.uniq.collect(&:inspect).join(", ")

    record.errors.add(attribute, :inclusion, **options.except(:in).merge!(rejected_values: formatted_rejected, value: value))
  end
end

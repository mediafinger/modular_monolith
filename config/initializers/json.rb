# OJ is a fast JSON serialization gem
# it is automagically used by jsonapi-serializer
#
# https://github.com/jsonapi-serializer/jsonapi-serializer
#
# https://github.com/ohler55/oj/blob/develop/pages/Modes.md
# https://github.com/ohler55/oj/blob/develop/pages/Options.md
#

Oj.optimize_rails # without this call JSON.parse does ignore the settings below

Oj.default_options = {
  mode: :compat, # mode for compatibility with the JSON gem, used by jsonapi-serializer

  allow_blank: true, # If true a nil input to load will return nil and not raise an Exception.
  bigdecimal_as_decimal: false, # If true dump BigDecimal as a decimal number otherwise as a String
  bigdecimal_load: :bigdecimal, # Determines how to load decimals.
  #                :bigdecimal convert all decimal numbers to BigDecimal. (bugged, therefore new options below)
  #                :float convert all decimal numbers to Float.
  #                :auto the most precise for the number of digits is used.
  compat_bigdecimal: true, # load decimals as BigDecimal instead of as a Float when in compat or rails mode.
  decimal_class: BigDecimal, # https://github.com/ohler55/oj/issues/628
  empty_string: false, # If true an empty or all whitespace input will not raise an Exception.
  # omit_nil: true, # If true, Hash and Object attributes with nil values are omitted.
  second_precision: 6, # The number of digits after the decimal when dumping the seconds of time
  symbol_keys: true, # Use symbols instead of strings for hash keys. :symbolize_names is an alias.
  time_format: :ruby, # The :time_format when dumping, jsonapi-serializer uses :ruby
}

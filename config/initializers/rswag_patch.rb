# Patch para evitar erro com Rswag em Rails 7 / Ruby 3.2+
module Rswag
  module Specs
    Rails = ::Rails unless const_defined?(:Rails)
  end
end

require 'test_helper'

class InformantTest < ActionView::TestCase

  test "text field" do
    # object_name, object, self, options, block
    p = lambda{ |b| b.text_field(:color) }
    b = Informant::Standard.new(:car, Object.new, @controller, {}) { p }
    assert_equal "", b
  end
end

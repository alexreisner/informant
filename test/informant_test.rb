require 'test_helper'

class InformantTest < ActionView::TestCase
  include ERB::Util

  test 'verify rendered field' do
    # object_name, object, self, options, [block for Rails < 4.0]
    form = Informant::Standard.new(:car, OpenStruct.new(color: 'red'), self, {})
    element = form.text_field(:color)
    expected = "<div id=\"car_color_field\" class=\"field\"><label>Color</label><br /><input type=\"text\" value=\"red\" name=\"car[color]\" id=\"car_color\" /></div>"
    assert_equal expected, element.gsub(/\n\s+/,'').strip
  end
end

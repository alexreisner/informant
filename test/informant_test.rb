require 'test_helper'

class InformantTest < ActionView::TestCase

  test "text field" do
    # object_name, object, self, options, block
    p = lambda{ |b| b.text_field(:color) }
    b = Informant::Standard.new(:car, Object.new, @controller, {}) { p }
    assert_equal "", b
  end

  test 'option required should be rendered' do
    form = Informant::Standard.new(:cc, OpenStruct.new(number: '123'), self, {})
    element = form.text_field(:number, required: true)
    expected = <<-EOT
    <div id=\"cc_number_field\" class=\"field\"><label>Number<span class=\"required\">*</span></label><br /><input required=\"required\" type=\"text\" value=\"123\" name=\"cc[number]\" id=\"cc_number\" /></div>
    EOT
    assert_equal expected.strip, element.gsub(/\n\s+/,'').strip
  end
end

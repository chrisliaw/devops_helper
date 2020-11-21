require "test_helper"

require "devops_helper"

class DevopsHelperTest < Minitest::Test
  include DevopsHelper::GemVersionHelper

  def test_increase

    test_cases = [
      ["", 4, "0.0.0.1"],
      ["", 1, "1.0"],
      ["1.0",1,"2.0"],
      ["1.0",2,"1.1.0"],
      ["2.22",4,"2.22.0.1"],
      ["2.14.2.11.22",1,"3.0.0.0.0"],
      ["1",3,"1.0.1"],
      ["1",1,"2.0"],
      ["1.0", 9, "1.0.0.0.0.0.0.0.1"]
    ]

    test_cases.each do |tc|
      res = increase_version(tc[0],tc[1])
      puts "#{tc[0]} / #{tc[1]} / #{tc[2]} / #{res}"
      assert(res == tc[2])
    end

  end

end

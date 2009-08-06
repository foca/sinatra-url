require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class TestUrl < Test::Unit::TestCase
  context "registering handlers with the url DSL" do
    test "registers urls at the DSL level and gives you access to them at the helper level" do
      mock_app {
        get url(:foo, "/foo") do
          assert_equal "/foo", url_for(:foo)
        end
      }

      get "/foo"
      assert last_response.ok?
    end

    test "can register a url with parameters" do
      mock_app {
        get url(:foo, "/foo/:name") do |name|
          assert_equal "bar", name
        end
      }

      get "/foo/bar"
      assert last_response.ok?
    end
  end
end

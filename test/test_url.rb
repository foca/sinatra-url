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

    test "can register an url without specifying a path if already registered" do
      mock_app {
        post url(:foo, "/foo/:name") do |name|
          assert_equal "bar", name
        end

        get url(:foo) do |name|
          assert_equal "bar", name
        end
      }
      get "/foo/bar"
      assert last_response.ok?
    end

  end

  context "generating urls with url_for for registered handlers" do
    test "generating urls with :named_params" do
      mock_app {
        get url(:foo, "/foo/:name") do |name|
          assert_equal "/foo/bar", url_for(:foo, :name => "bar")
        end
      }
      get "/foo/bar"
      assert last_response.ok?
    end

    test "generating urls with splat args" do
      mock_app {
        get url(:foo, "/say/*/to/*") do
          assert_equal "/say/hi/to/mom", url_for(:foo, :splat => ["hi", "mom"])
        end
      }
      get "/say/hi/to/mom"
      assert last_response.ok?
    end

    test "generating urls with extra arguments for GET" do
      mock_app {
        get url(:foo, "/foo/:name") do |name|
          assert_equal "/foo/bar?get=param", url_for(:foo, :name => "bar", :get => 'param')
        end
      }
      get "/foo/bar"
      assert last_response.ok?
    end
  end

  context "generating urls with url_for for unregistered handlers" do
    test "should raise ArgumentError" do
      assert_raise ArgumentError do
        mock_app {
          get "/" do
            url_for(:unknown)
          end
        }
        get "/"
      end
    end
  end
end

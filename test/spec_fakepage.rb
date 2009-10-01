require 'curb'
require File.expand_path('../../lib/fakepage', __FILE__)

FakePage.start

def request(name, options = {})
  options[:method] ||= :get
  options[:postdata] ||= {}

  page = FakePage.new(name, { :code => 200 }.merge(options))

  args = []
  if options[:method] == :post
    options[:postdata].each do |k, v|
      args << Curl::PostField.content(k.to_s, v)
    end
  end

  Curl::Easy.perform(page.url) do |curl|
    curl.send(:"http_#{options[:method]}", *args)
  end
end

describe "FakePage" do

  it "should have methods for get and post http methods" do
    FakePage.respond_to?(:get).should.be.true
    FakePage.respond_to?(:post).should.be.true
  end

  describe "performing requests" do

    allowed_methods = [:get, :post]

    allowed_methods.each do |amethod|
      
      describe amethod.to_s.upcase do
        
        before do
          @page = FakePage.new("do_#{amethod}", :method => amethod)
        end

        it "should returns status code 200 for #{amethod}" do
          response = Curl::Easy.perform(@page.url) do |curl|
            curl.send(:"http_#{amethod}")
          end

          response.response_code.should.be.equal 200
        end

        allowed_methods.select { |m| m != amethod }.each do |not_allowed_method|

          it "should returns status code 405 for #{not_allowed_method}" do
            response = Curl::Easy.perform(@page.url) do |curl|
              curl.send(:"http_#{not_allowed_method}")
            end

            response.response_code.should.be.equal 405
          end
        end
      end
    end
  end

  describe "server configurations" do

    it "should have a default port" do
      FakePage.options[:server_port].should.be.equal 9292
    end

    it "should change the default port" do
      FakePage.stop

      FakePage.start(:server_port => 9876)
      response = request("default_port_change")
      response.url.should.include "9876"
    end
  end

  describe "options" do

    describe "defaults" do
      it "should define empty for nil :body" do
        response = request("nil_body")
        response.body_str.should.be.empty
      end
      
      it "should define 200 for nil :code" do
        response = request("nil_status_code")
        response.response_code.should.be.equal 200
      end
      
      it "should define 'text/plain' for nil :content_type" do
        response = request("nil_content_type")
        response.content_type.should.be.equal "text/plain"
      end
    end

    describe "custom" do
      it "should accept :body" do
        response = request("body", :body => "body of my page")
        response.body_str.should.be.equal "body of my page"
      end

      it "should accept :code for status code" do
        response = request("status_code", :code => 404)
        response.response_code.should.be.equal 404
      end

      it "should accept :content_type" do
        response = request("content_type", :content_type => "text/html")
        response.content_type.should.be.equal "text/html"
      end
      
      it "should accept :postdata" do
        response = request("content_type", :postdata => { :field => 'value' }, :method => :post)
        response.response_code.should.be.equal 200
      end
    end
  end
end
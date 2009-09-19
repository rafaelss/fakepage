require 'curb'
require File.expand_path('../../lib/fakepage', __FILE__)

FakePage.start

def request(name, options = {})
  page = FakePage.new(name, { :code => 200 }.merge(options))
  Curl::Easy.perform(page.url)
end

describe "FakePage" do

  it "should have methods for get, post, put and head http methods" do
    FakePage.respond_to?(:get).should.be.true
    FakePage.respond_to?(:post).should.be.true
    FakePage.respond_to?(:put).should.be.true
    FakePage.respond_to?(:head).should.be.true
  end

  describe "performing requests" do

    allowed_methods = [:get, :post, :put, :head]

    allowed_methods.each do |method|
      
      describe method.to_s.upcase do
        
        before do
          @page = FakePage.new("do_#{method}", :method => method)
        end

        it "should returns status code 200 for #{method}" do
          response = Curl::Easy.perform(@page.url) do |curl|
            if method == :put
              curl.send(:"http_#{method}", "data")
            else
              curl.send(:"http_#{method}")
            end
          end

          response.response_code.should.be.equal 200
        end

        allowed_methods.select { |m| m != method }.each do |not_allowed_method|

          it "should returns status code 405 for #{not_allowed_method}" do
            response = Curl::Easy.perform(@page.url) do |curl|
              if not_allowed_method == :put
                curl.send(:"http_#{not_allowed_method}", "data")
              else
                curl.send(:"http_#{not_allowed_method}")
              end
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
    end
  end
end
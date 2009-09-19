require 'rack/handler/thin'

class FakePage
  include Rack

  attr_accessor :url

  def initialize(name, options)
    @url = "http://localhost:#{@@options[:server_port]}/#{name}"

    @@maps ||= {}
    @@maps["/#{name}"] = lambda do |env|
      options[:method] ||= :get

      headers = { 'Content-Type' => options[:content_type] || 'text/plain' }
      if options[:method].to_s.upcase == env['REQUEST_METHOD']
        code = options[:code] || 200
        body = options[:body] || ""
      else
        #puts 
        #puts '-------------'
        #puts "#{options[:method].to_s.upcase} == #{env['REQUEST_METHOD']}"

        code = 405
        body = Rack::Utils::HTTP_STATUS_CODES[code]
      end
      [ code, headers, [ body ] ]
    end
    @@urlmap.remap(@@maps)
  end

  def self.get(name, options)
    self.new(name, options.merge(:method => :get))
  end

  def self.post(name, options)
    self.new(name, options.merge(:method => :post))
  end

  def self.put(name, options)
    self.new(name, options.merge(:method => :put))
  end

  def self.head(name, options)
    self.new(name, options.merge(:method => :head))
  end

  def self.options
    @@options || {}
  end

  def self.start(options = {})
    @@options = { :server_port => 9292 }.merge(options)

    @@urlmap = URLMap.new
    @@thread = Thread.new do
      Thin::Logging.silent = true
      Handler::Thin.run(Lint.new(@@urlmap), :Host => '0.0.0.0', :Port => @@options[:server_port])
    end
    at_exit do
      @@thread.kill
    end

    sleep(1)
  end

  def self.stop
    @@thread.kill
  end
end
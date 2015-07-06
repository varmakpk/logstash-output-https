# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"

require "net/http"
require "net/https"
require 'openssl'


# Ugly monkey patch to get around http://jira.codehaus.org/browse/JRUBY-5529
Net::BufferedIO.class_eval do
    BUFSIZE = 1024 * 16

    def rbuf_fill
      timeout(@read_timeout) {
        @rbuf << @io.sysread(BUFSIZE)
      }
    end
end


# An example output that does nothing.
class LogStash::Outputs::Https < LogStash::Outputs::Base
  config_name "https"

  config :host, :validate => :string,  :required => true
  config :proto, :validate => :string, :default => "https"
  config :crtfile, :validate => :string,  :required => true
  config :keyfile, :validate => :string,  :required => true
  config :keyphrase, :validate => :string,  :required => true

  public
  def register
  end # def register

  public
  def receive(event)
    return unless output?(event)

    if event == LogStash::SHUTDOWN
      finished
      return
    end

    # Send the event over https.

	#cert = File.read("D:\\LocalSVN\\SaaS\\Intelligent Collector\\ECRunPath\\client.crt")		
    #keyfile = File.read("D:\\LocalSVN\\SaaS\\Intelligent Collector\\ECRunPath\\client.key")


    url = URI.parse("#{@proto}://#{@host}/")
    @logger.info("HTTPS URL", :url => url)
    http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	http.cert = OpenSSL::X509::Certificate.new(File.read("#{@crtfile}"))
    http.key = OpenSSL::PKey::RSA.new(File.read("#{@keyfile}"), "#{@keyphrase}")
 
    request = Net::HTTP::Post.new(url.path)
    request.body = event.to_json
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
       @logger.info("Event send to Loggly OK!")
    else
       @logger.warn("HTTP error", :error => response.error!)
    end
  end # def receive


end # class LogStash::Outputs::Https

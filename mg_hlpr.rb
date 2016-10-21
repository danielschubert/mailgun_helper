require 'rest-client'
require 'json'

DOMAIN_NAME = "YOUR_DOMAIN"
API_KEY = "YOUR_KEY"
LIST = "YOUR_LIST"

# Reads a line separated list
def add_list_member(f)
  File.open f, 'r' do |file|
    file.each do |email|
      print email
      RestClient.post("https://api:key-#{API_KEY}" \
                                        "@api.mailgun.net/v3/lists/#{LIST}@#{DOMAIN_NAME}/members",
                      :subscribed => true,
                      :address => email.chomp!,
                      :upsert => true )
    end
  end
end

# Reads a line separated list
def delete_list_member(f)
  File.open f, 'r' do |file|
    file.each do |email|
      begin
        print email
        email.chomp!
        RestClient.delete("https://api:key-#{API_KEY}" \
                          "@api.mailgun.net/v3/lists/#{LIST}@#{DOMAIN_NAME}/members/#{email}")
      rescue
        puts "--------\n#{email} Not found..NEXT\n"
        next
      end
    end
  end
end

def send_scheduled_message
  RestClient.post "https://api:key-#{API_KEY}"\
  "@api.mailgun.net/v3/#{DOMAIN_NAME}/messages",
  :from => "EXAMPLE<example@example.com>",
  :to => "#{LIST}@#{DOMAIN_NAME}",
  :subject => "Test SUbject",
  :text => "Testing some Mailgun awesomeness!  %mailing_list_unsubscribe_url% ",
  :html => "<h1>html test</h1>",
  "o:deliverytime" => "Thur, 08 Oct 2015 21:46:00 +0200"
end

def send_message
  RestClient.post "https://api:key-#{API_KEY}"\
  "@api.mailgun.net/v3/#{DOMAIN_NAME}/messages",
  :from => "EXAMPLE<example@example.com>",
  :to => "test@mg.danletard.de",
  :subject => "Subject",
  :text => "
  Text, more Text, even more Text, even more awesome Text,

  %unsubscribe_url%
  ",
  :html => ''
end

def get_logs
    RestClient.get "https://api:key-#{API_KEY}"\
        "@api.mailgun.net/v3/#{DOMAIN_NAME}/events",
        :params => {
            :"event" => 'failed'
        }
end

def get_bounces
    RestClient.get "https://api:key-#{API_KEY}"\
        "@api.mailgun.net/v3/#{DOMAIN_NAME}/bounces"
end


delete_list_member("emails.csv")
#add_list_member("emails.csv")
#send_message
#puts JSON::parse(get_bounces)
#puts JSON::parse(get_logs)

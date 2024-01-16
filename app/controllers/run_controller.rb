require 'twilio-ruby'
require 'google-search'
#require 'config'
#require 'google-search-results'

class RunController < ApplicationController

    def app
        account_sid = config.TWILIO_ACCOUNT_SID
        auth_token  = config.TWILIO_AUTH_TOKEN
        client      = Twilio::REST::Client.new(account_sid, auth_token)

        # Retrieve the latest message from the queue
        message = client.messages.list(limit: 1).first        

        if message && !message.body.nil? && !message.body.empty?
            # Get the number of the sender from Twilio
            sender_number = message.from

            # Print the message body
            puts "Latest message:: from: #{sender_number} - #{message.body}"

            # Get response from Google Search API
            response = get_first_google_search_result(message.body)
            send_sms(sender_number, response)

            # Delete the message from the queue
            message.delete

            # Send javascript to refresh page in 5 seconds
            respond_to do |format|
                format.js { render inline: "setTimeout(function(){ window.location.reload(); }, 5000);" }
            end
        end
    end

    private

    def get_first_google_search_result(query)
        client = GoogleSearchResults.new(q: query)
        results = client.get_hash["organic_results"]
        body = results.first["title"] + "\n" + results.first["link"]
        body
    end

    def send_sms(to_number, body)
        account_sid      = config.TWILIO_ACCOUNT_SID
        auth_token       = config.TWILIO_AUTH_TOKEN
        bot_phone_number = config.TWILIO_PHONE_NUMBER
        client = Twilio::REST::Client.new(account_sid, auth_token)
        client.messages.create(
            from: bot_phone_number,
            to: to_number,
            body: body
        )
    end
end
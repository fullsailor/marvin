require File.expand_path('../../lib/marvin', __FILE__)

RSpec::Matchers.define :reply_to do |message|
  chain :with do |response|
    @expected_response = response
  end

  match do |bot|

    # Run through Marvin's logic chain
    bot.handle_message({user_id: "1", body: message})

    # Hacky way to get Marvin's last response
    @actual_response = bot.instance_variable_get('@response')

    if @expected_response
      # Does it match
      @actual_response == @expected_response
    else
      # Did it respond at all?
      @actual_response
    end
  end

  failure_message_for_should do |bot|
    if @expected_response
      %Q[Marvin replied to "#{@message}" with "#{@actual_response}". Expected "#{@expected_response}".]
    else
      # Figure it out later
    end
  end

end

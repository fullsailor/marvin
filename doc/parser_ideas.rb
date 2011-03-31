class NightTimeDayTimeBehavior < Marvin::Behavior

  condition lambda { playing_nighttime_daytime? } do

    match /nightt?ime!?/i do
      say "daytime!"
    end

    match /daytime!?/i do
      say "nighttime!"
    end

  end

  condition lambda { !playing_nighttime_daytime? } do

    match /do you want to play a game of nighttime daytime\?/i do
      say %w( nighttime! daytime! ).sample
      play!
    end

  end

  def playing_nighttime_daytime?
    convo.session[:playing_nighttime_daytime]
  end

  def play!
    convo.session[:playing_nighttime_daytime] = true
  end

end



# Actions

# Post message
def say(); end

# Say and add to convo
def respond(); end

# Do nothing
def ignore(); end

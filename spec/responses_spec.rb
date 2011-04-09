require 'spec_helper'

describe "Responses" do

  before(:all) do
    class Marvin::Bot
      def initialize
        @room = Class.new do 
                   def user(id)
                     {name: "Test User"}
                   end
        end.new
      end
      def join_room!
      end
      def leave_room!
      end
      def say(text)
        @response = text
      end
    end
  end

  let(:bot) { Marvin::Bot.new }

  subject { bot }
  
  context 'Who am I' do 

    it { should reply_to('Marvin, who am I?').with("You're Test User") }
  end

  context 'Nighttime/Daytime' do
    it { should reply_to('Nighttime!').with("Daytime!") }
    it { should reply_to('Daytime!').with("Nighttime!") }
  end

  context 'Memory' do
    it 'should not remember something new' do
      should reply_to("Marvin, remember something you do not know").
                with("Nope, I don't remember that.") 
    end
    it 'should remember with `is` keyword' do
      should reply_to("Marvin, remember testing is good").
                with("Okay, I've got it")
      should reply_to("Marvin, remember testing").
                with("testing is good")
    end
    it 'should remember with `and` keyword' do
      should reply_to("Marvin, remember cats are evil").
                with("Okay, I've got it") 
      should reply_to("Marvin, remember cats").
                with("cats are evil")
    end
  end

  context 'ShutUp' do
    # TODO: refactor reply_to to allow an array of messages
    # reply_to("Something", "Something!")
    # Flags might be useful too. :?, :!, :nocase
    it { should reply_to("Shut up marvin").with("You shut up!") }
    it { should reply_to("Shut up marvin!").with("You shut up!") }
    it { should reply_to("Shutup marvin!").with("You shut up!") }
    it { should reply_to("Marvin shut up!").with("You shut up!") }
    it { should reply_to("Marvin shutup!").with("You shut up!") }
  end

  context 'Affirmatives' do
    it { should reply_to("Yes").with("Fantastic!") }
    it { should reply_to("Yep").with("Fantastic!") }
    it { should reply_to("Yessir").with("Fantastic!") }
  end
  
  context 'Negatives' do
    it { should reply_to("No").with("Well why not?") }
    it { should reply_to("Nope").with("Well why not?") }
  end

  it { should reply_to('Marvin, something ').with("Are you talking to me?") }

  it { should_not reply_to("Barnacles") }
  
end

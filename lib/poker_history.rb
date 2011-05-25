require "active_support"

module PokerHistory
  autoload :Game, 'poker_history/game'
  autoload :Player, 'poker_history/player'
  autoload :Action, 'poker_history/action'
  autoload :Event, 'poker_history/event'
  
  module Rooms
    autoload :Base, 'poker_history/rooms/base'
    autoload :PokerStars, 'poker_history/rooms/poker_stars'
    autoload :PartyPoker, 'poker_history/rooms/party_poker'
    autoload :FullTilt, 'poker_history/rooms/full_tilt'
  end
  
  module Utils
    autoload :TimeStringConverter, 'poker_history/utils/time_string_converter'
    autoload :Cards, 'poker_history/utils/cards'
    autoload :Rules, 'poker_history/utils/rules'
  end
  
  def self.parse(source)
    klass = case source
      when /^PokerStars\s+Game/i, /^Игра\s+PokerStars/i then Rooms::PokerStars
      when /^Full\s+Tilt\s+Poker/i then Rooms::FullTilt
      when /^Redstar/ then nil
      when /^UltimateBet/ then nil
      when /^\*+\s+Hand\s+History\s+for\s+Game\s+\d+\s+\*+/i then Rooms::PartyPoker
      else nil
    end
    
    klass.new(source).parse if klass
  end
end

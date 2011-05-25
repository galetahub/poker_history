module PokerHistory
  module Rooms
    class ParseError < RuntimeError; end
    
    class Base
      CASH = "[0-9$,.]+"
      
      attr_accessor :source, :game
      
      def initialize(source)
        @source = source.to_s.strip
        @parsed = false
        @game = Game.new("Noname", determine_game(@source))
      end
      
      def parsed?
        @parsed && @game.valid?
      end
      
      def parse
        @source.each_line { |line| parse_line(line.strip) }        
        @game.generate_positions!
        @parsed = true
        self
      end
      
      def room_name
        'Base'
      end
      
      protected
      
        def parse_line(line)
          raise NotImplementedError, "It should be overwritten by adapter"  
        end
        
        def ignorable?(line)
          raise NotImplementedError, "It should be overwritten by adapter"  
        end
        
        def determine_game(source)
          raise NotImplementedError, "It should be overwritten by adapter"
        end
        
        def cash_to_d(string)
          return 0.0 if string.nil? || string.empty?
          string.gsub!(/[$, ]/,"")
          string.to_f
        end
        
        def parse_event_kind(value)
          case value.to_s.strip
            when 'малый' then 'small'
            when 'большой' then 'big'
            when 'малый и большой' then 'small_and_big'
            when 'колл' then 'calls'
            when 'бет' then 'bets'
            when 'фолд' then 'folds'
            when 'чек' then 'checks'
            when 'олл-ин', 'и олл-ин' then 'all-in'
            else value
          end
        end
        
        def parse_limit_type(value)
          case value.to_s.strip
            when /Pot/i, /Пот\-лимит/ then 'PL'
            when /No/i, /Безлимитный/ then 'NL'
            else 'FL'
          end
        end
    end
  end
end

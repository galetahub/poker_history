module PokerHistory
  module Utils
    class Rules
      MAX_SEATS = 12
      
      POSITION_NAMES = { 2 =>  'BB',
                         3 =>  'BB SB',
                         4 =>  'CO BB SB',
                         5 =>  'CO UTG BB SB',
                         6 =>  'CO LP UTG BB SB',
                         7 =>  'CO LP MP UTG BB SB',
                         8 =>  'CO LP MP UTG+1 UTG BB SB',
                         9 =>  'CO LP MP2 MP1 UTG+1 UTG BB SB',
                         10 => 'CO LP MP2 MP1 EP UTG+1 UTG BB SB',
                         11 => 'CO LP2 LP1 MP2 MP1 EP UTG+1 UTG BB SB' }
      class << self
        def position_names(players_count)
          if POSITION_NAMES.key?(players_count)
            POSITION_NAMES[players_count].split(/\s/)
          else
            raise ParseError.new("invalid players_count, must be in 2-11: #{players_count}")
          end
        end
        
        def rounds(game_type)
          case game_type
            when 'HE', 'OH' then %w( Preflop Flop Turn River )
            when 'ST' then %w( Third Fourth Fifth Sixth River )
            else nil
          end
        end
      end
    end
  end
end

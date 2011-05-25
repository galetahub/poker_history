module PokerHistory
  class Player
    attr_accessor :name, :position_name, :seat, :chips, :kind, :stake
    attr_accessor :hero, :winner, :sum, :game
    
    #
    # kind: 'small_blind', 'big_blind', 'dealer' ('button'), 'default'
    #
    def initialize(name, seat, chips = 0)
      @name = name
      @seat = seat.to_i
      
      if @name.blank? || @seat.zero?
        raise ParseError.new("Player name cannot be blank, seat cannot be zero")
      end
      
      @chips = chips
      @stake = 0.0
      @sum = 0.0
      @cards = nil
      @str_cards = nil
      @kind = 'default'
      @hero = false
      @winner = false
      @position = nil
      @position_name = nil
      @game = nil
    end
    
    def hero?
      @hero
    end
    
    def winner?
      @winner
    end
    
    def blinder?
      ['big_blind', 'small_blind'].include?(@kind.to_s)
    end
    
    def make_stake(amount)
      @stake += amount
    end
    
    def set_kind(value)
      @kind = parse_kind(value)
    end
    
    def cards
      @cards ||= Utils::Cards.parse(@str_cards)
    end
    
    def cards=(value)
      if value.is_a?(Array)
        @cards = value 
      else
        @str_cards = value.to_s
      end
    end
    
    def all_in!
      value = (@chips - @stake)
      make_stake(value)
      value
    end
    
    def make_raise(amount)
      value = amount #blinder? ? (amount - @game.blinds_amounts[:sb]) : amount
      make_stake(value)
      value
    end
    
    protected
    
      def parse_kind(value)
        case value.to_s.downcase
          when 'small' then 'small_blind'
          when 'big' then 'big_blind'
          when 'button', 'dealer' then 'dealer'
          else 'default'
        end
      end
  end
end

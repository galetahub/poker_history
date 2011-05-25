module PokerHistory
  class Event
    attr_accessor :amount, :player, :action, :kind, :cards, :pot, :cards_count
    
    #
    # kind: 'ante', 'bets', 'checks', 'folds', :shows, :mucks, :wins, :small, :big, :calls, :small_and_big, :reset, :noreset
    #
    def initialize(player, attributes = {})
      @player = player
      @kind = attributes[:kind]
      @amount = attributes[:amount]
      @cards_count = attributes[:cards_count]
      
      @pot = (@amount || 0).to_f
      @cards = Utils::Cards.parse(attributes[:cards]) unless attributes[:cards].blank?
      
      if @player.nil? || @kind.blank?
        raise ParseError.new("Event player cannot be nil, kind cannot be blank")
      end
      
      set_player_kind
      calc_player_stake
    end
    
    def self.summary?(kind)
      ['wins', 'shows', 'mucks', 'not_show'].include?(kind.to_s.downcase)
    end
    
    def set_player_kind
      @player.set_kind(@kind) if ['small', 'big'].include?(@kind)
    end
    
    def summable?
      @amount && ['ante', 'bets', 'calls', 'small', 'big', 'raises', 'all-in'].include?(@kind)
    end
    
    def raises?
      @kind == 'raises'
    end
    
    def folds?
      @kind == 'folds'
    end
    
    def calc_player_stake
      case @kind
        when 'ante', 'bets', 'calls', 'small', 'big' then @player.make_stake(@amount)
        when 'raises' then @pot = @player.make_raise(@amount)
        when 'all-in' then @pot = @amount = @player.all_in!
        when 'wins' then 
          @player.winner = true
          @player.sum = @amount
      end
    end
  end
end

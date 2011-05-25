module PokerHistory
  class Action
    attr_accessor :kind, :events, :total_pot, :previous_pot, :cards, :board
    
    #
    # kind: 'preflop', 'flop', 'turn', 'river', 'showdown', 'exchange'
    #
    def initialize(attributes)
      @kind = attributes[:kind].to_s
      
      @players_count = (attributes[:players_count] || 0)
      @previous_pot = (attributes[:previous_pot] || 0)
      
      @cards = Utils::Cards.parse(attributes[:cards])
      @board = attributes[:board] || []
      
      @events = []
    end
    
    def visible?
      ['preflop', 'flop', 'turn', 'river'].include?(@kind)
    end
    
    def cards=(value)
      if value.is_a?(Array)
        @cards = value 
      else
        @str_cards = value.to_s
      end
    end
    
    def summable_events
      @events.select{|e| e.summable? }
    end
    
    def total_pot
      @previous_pot + summable_events.map(&:pot).compact.sum
    end
    
    def players_outs
      @events.select { |e| e.folds? }.size 
    end
    
    def players_count
      unless @events.empty?
        @players_count = @events.collect { |e| e.player.name }.uniq.size
      else
        @players_count
      end
    end
  end
end

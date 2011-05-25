module PokerHistory
  class Game
    attr_accessor :title, :date, :table_name, :total_pot, :rake, :max_players
    attr_accessor :players, :actions, :blinds_amounts, :description, :button_seat
    attr_accessor :board, :stakes_type, :tournament, :events, :summary_events, :kind, :limit
    
    # Game
    #
    # kind: HE, OH, 7S, ST
    # limit: NL, FL, PL
    #
    def initialize(title, kind, date = nil)
      @title = title
      @kind = kind
      @date = date
      @table_name = nil
      @total_pot = 0.0
      @rake = 0.0
      @blinds_amounts = { :bb => 0, :sb => 0, :ante => 0 }
      @max_players = 0
      @button_seat = -1
      @actions = []
      @players = []
      @events = []
      @summary_events = []
      @hero = nil
      @limit = 'NL'
    end
    
    def hero
      @hero ||= players.detect { |pl| pl.hero? }
    end
    
    def winner
      @winner ||= winners.first
    end
    
    def winners
      @winners ||= players.select { |pl| pl.winner? }
    end
    
    def button
      @button ||= players.detect { |pl| pl.seat == @button_seat }
    end
    
    def buy_in
      @blinds_amounts[:bb] * 100
    end
    
    def visible_actions
      @actions.select { |ac| ac.visible? }
    end
    
    # Limit kind
    # MicroLimits, LowLimits, AverageLimits, HighLimits, UltrahighLimits
    #
    def limit_kind
      case @limit
        when 'NL', 'PL' then
          case buy_in
            when 2..19 then 'MicroLimits'
            when 20..199 then 'LowLimits'
            when 200..999 then 'AverageLimits'
            when 1000..9999 then 'HighLimits'
            when 10000..9999999 then 'UltrahighLimits'
          end
        when 'FL' then
          case buy_in
            when 4..20 then 'MicroLimits'
            when 21..199 then 'LowLimits'
            when 200..799 then 'AverageLimits'
            when 800..9999 then 'HighLimits'
            when 10000..9999999 then 'UltrahighLimits'
          end
      end
    end
    
    def add_player(attributes)
      player = Player.new(attributes[:name], attributes[:seat], attributes[:chips])
      player.set_kind('button') if player.seat == @button_seat.to_i
      player.game = self
      @players << player
    end
    
    def add_action(attributes)
      attributes[:previous_pot] ||= (current_action.nil? ? initial_pot_size : current_action.total_pot)
      attributes[:players_count] ||= (current_action.nil? ? players_count : current_action.players_count)
      attributes[:board] ||= @actions.map(&:cards).flatten.compact
      
      @actions << Action.new(attributes)
    end
    
    def add_event(attributes)
      player = find_player(attributes.delete(:player))
      event = Event.new(player, attributes)
      
      if Event.summary?(attributes[:kind])
        @summary_events << event
      elsif current_action
        current_action.events << event
      else
        @events << event
        value = attributes[:amount].to_f
        case attributes[:kind]
          when 'ante' then @blinds_amounts[:ante] = value
          when 'big' then @blinds_amounts[:bb] = value
          when 'small' then @blinds_amounts[:sb] = value
        end
      end
    end
    
    def current_action
      @actions.last
    end
    
    def update_blinds_ante(value)
      @blinds_amounts[:ante] = value.to_f
    end
    
    def dealt(player_name, cards)
      player = find_player(player_name)
      if player
        player.cards = cards
        player.hero = true
      end
    end
    
    def find_player(value)
      player = @players.detect { |pl| pl.name == value }
      raise ParseError.new("Player by name #{value} not found") if player.nil?
      player
    end
    
    def has_player?(value)
      !@players.detect { |pl| pl.name == value }.nil?
    end
    
    def players_count
      @players.size
    end
    
    def initial_pot_size
      (players_count * blinds_amounts[:ante]) + blinds_amounts[:bb] + blinds_amounts[:sb]
    end
    
    def total_pot
      @total_pot = calc_total_pot if @total_pot == 0.0
      @total_pot
    end
    
    def board
      @board ||= actions.map(&:cards).compact.flatten
    end
    
    def board=(value)
      @board = Utils::Cards.parse(value)
    end
    
    def update(attributes)
      attributes.each do |key, value|
        send("#{key}=", value)
      end
    end
    
    def valid?
      ![hero.nil?, winner.nil?, button.nil?, players_count.zero?, actions.empty?].any?
    end
    
    # generate positions names for players
    def generate_positions!
      position_names = Utils::Rules.position_names(players_count)
      sorted_players = players.sort_by(&:seat)
      
      # Find the button and name the seats after the button
      sorted_players.each do |player|
        player.position_name = 'BTN' if player.seat == @button_seat
        
        if player.seat > @button_seat
          player.position_name = position_names.pop
        end
      end
      
      # The seats before the button are named in order until we run out of seat
      sorted_players.each do |player|
        if player.seat < @button_seat
          player.position_name = position_names.pop
        end
      end
    end
    
    protected
    
      def calc_total_pot
        ante_pot_size = actions.map(&:summable_events).flatten.map(&:amount).sum
        initial_pot_size + ante_pot_size
      end
  end
end

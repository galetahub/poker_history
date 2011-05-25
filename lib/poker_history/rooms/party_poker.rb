module PokerHistory
  module Rooms
    class PartyPoker < Base
      
      def room_name
        'PartyPoker'
      end
      
      protected
      
        def parse_line(line)
          case line
            when /\*+\s+Hand\s+History\s+for\s+Game\s+(\d+)\s+\*+/i then
              @game.update :title => "PP#{$1}"
            when /(#{CASH})\s+NL\s+Texas\s+Hold'em\s+\-\s+(.*)$/i then
              @game.update :date => Utils::TimeStringConverter.new($2).as_utc_datetime,
                :stakes_type => cash_to_d($1), :limit => 'NL'
            when /(#{CASH})\s+(USD\s+)?(NL|PL)\s+(.+)\s+\-\s+(.*)$/i then
              @game.update :date => Utils::TimeStringConverter.new($5).as_utc_datetime,
                :stakes_type => cash_to_d($1), :limit => $3, :description => $4
            when /^Tourney\s+(Hand\s+)?(NL|PL)\s+(.+)\s+\-\s+(.*)$/i then
              @game.update :date => Utils::TimeStringConverter.new($4).as_utc_datetime, 
                :limit => $2, :description => ["Tourney", $1, $2, $3].map(&:strip).join(' ')
            when /^Table (.*)$/ then
              @game.update :table_name => $1
            when /^Seat (\d+) is the button/ then
              @game.update :button_seat => $1.to_i
            when /^Total number of players\s*:\s*(\d+)/ then
              @game.update :max_players => $1.to_i
            when /^Seat\s+(\d+)\:\s+(.+)\s+\(\s*(#{CASH})\s*(USD\s+)?\)/ then
              @game.add_player :name => $2, :seat => $1.to_i, :chips => cash_to_d($3)
            when /(.*)\s+posts\s+(small|big)\s+blind\s+\[(#{CASH})(\s+USD)?\]/ then
              @game.add_event(:kind => $2, :amount => cash_to_d($3), :player => $1)
            when /\*+\s+Dealing down cards\s+\*+/ then
              @game.add_action(:kind => 'preflop')
            when /^Dealt to\s+(\w+)\s+\[([^\]]+)\]/ then
              @game.dealt($1, $2)
            when /(.+)\s+posts\s+ante\s+(of\s+)?\[(#{CASH})(\s+USD)?\]/ then
              @game.add_event(:kind => 'ante', :amount => cash_to_d($3), :player => $1)
            when /(.+)\s+(folds|checks)/ then
              @game.add_event(:kind => $2, :player => $1)
            when /(.+)\s+(calls|bets)\s+\[([0-9$,.]+)(\s+USD)?\]/ then
              @game.add_event(:kind => $2, :player => $1, :amount => cash_to_d($3))
            when /(.+)\s+raises\s+\[([0-9$,.]+)(\s+USD)?\]/ then
              @game.add_event(:kind => 'raises', :player => $1, :amount => cash_to_d($2))
            when /\*+\s+Dealing Flop\s+\*+\s+\[(.*)\]/ then
              @game.add_action(:kind => 'flop', :cards => $1)
            when /(.+)\s+is\s+all-in/i then
              @game.add_event(:kind => 'all-in', :player => $1)
            when /\*+\s+Dealing Turn\s+\*+\s+\[(.*)\]/ then
              @game.add_action(:kind => 'turn', :cards => $1)
            when /\*+\s+Dealing River\s+\*+\s+\[(.*)\]/ then
              @game.add_action(:kind => 'river', :cards => $1)
            when /(.*)\s+shows \[(.*)\]/ then
              @game.add_event(:kind => 'shows', :player => $1, :cards => $2)
            when /(.*)\s+wins\s+(#{CASH})\s+from\s+the\s+(side|main)?\s+pot/, /(.*)\s+wins\s+([0-9,.$]+)(\s+USD)?/ then
              @game.add_event(:kind => 'wins', :player => $1, :amount => cash_to_d($2))
            when /(.*)\s+doesn't\s+show(\s+\[(.*)\])?/ then
              @game.add_event(:kind => 'not_show', :player => $1, :cards => $3)
            else
              raise ParseError, "#{room_name} invalid line for parse: #{line}" unless ignorable?(line)
          end
        end
        
        def determine_game(source)
          case source
            when /Hold'em\s+\-\s+/, /Hold'em[^\n]*Trny:\d+/ then 'HE'
            when /Omaha\s+\-\s+/i, /Omaha Hi\/Lo/i then 'OH'
            when /7\s+Card\s+Stud\s+\-\s+/i, /7\s+Stud\s+Hi\/Lo/i then '7S'
          end
        end
        
        def ignorable?(line)
          regular_expressions_for_ignorable_phrases = [
            /^>/
          ]
          
          regular_expressions_for_ignorable_phrases.any?{|re| re =~ line }
        end
    end
  end
end

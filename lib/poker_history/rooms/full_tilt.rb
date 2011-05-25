module PokerHistory
  module Rooms
    class FullTilt < Base
      def room_name
        'FullTilt'
      end
      
      protected
      
        def parse_line(line)
          case line
            when /^Full\s+Tilt\s+Poker\s+Game\s+\#([0-9]+):(.*)\s+\(partial\)$/ then
              raise ParseError.new("It's only partial, need full: #{line}")
            when /^Full\s+Tilt\s+Poker\s+Game\s+\#([0-9]+):\s+Table\s+(.*)\s+\((\d+)\s+max\)\s+\-\s+(#{CASH})\/(#{CASH})\s+\-\s+(Pot |No |)Limit\s+Hold'em\s+\-\s+(.*)$/i then
              @game.update(:title => "FT#{$1}",
                :table_name => $2, :max_players => $3.to_i,
                :date => Utils::TimeStringConverter.new($7).as_utc_datetime, 
                :description => "#{$4}/#{$5} Hold'em #{$6}Limit", 
                :stakes_type => cash_to_d($5), :limit => parse_limit_type($6),
                :blinds_amounts => {:sb=> $4.to_f, :bb=> $5.to_f, :ante => 0.0} )
            when /^Full\s+Tilt\s+Poker\s+Game\s+\#([0-9]+):\s+(#{CASH})\s+\+\s+(#{CASH})\s+(.*),\s+Table\s+(.*)\-\s+(Pot |No |)Limit\s+Hold'em\s+\-\s+(.*)$/ then
              @game.update(:title => "FT#{$1}",
                :table_name => $5,
                :date => Utils::TimeStringConverter.new($7).as_utc_datetime, 
                :description => "#{$2}+#{$3} Hold'em #{$6}Limit", 
                :stakes_type => cash_to_d($2), :limit => parse_limit_type($6),
                :blinds_amounts => {:sb=> $3.to_f, :bb=> $2.to_f, :ante => 0.0} )
            when /^Full\s+Tilt\s+Poker\s+Game\s+\#([0-9]+):(\s+.*,)?\s+Table\s+(.*)\s+\-\s+([0-9$.,]+)\/([0-9$.,]+)\s+(Ante\s+([0-9$.,]+)\s+)?\-\s+([0-9,$.]+\s+Cap\s+)?(Pot |No |)Limit\s+Hold'em\s+\-\s+(.*)$/i then
              @game.update(:title => "FT#{$1}",
                :table_name => $3,
                :date => Utils::TimeStringConverter.new($10).as_utc_datetime, 
                :description => "#{$4}/#{$5} Hold'em #{$9}Limit", 
                :stakes_type => cash_to_d($5), :limit => parse_limit_type($9),
                :blinds_amounts => {:sb=> $4.to_f, :bb=> $5.to_f, :ante => cash_to_d($7) } )
            when /^Seat\s+(\d+):\s*(.+)\s+\(\s*(#{CASH})\s*\)$/i then
              @game.add_player :name => $2, :seat => $1.to_i, :chips => cash_to_d($3)
            when /^Seat\s+(\d+):\s*(.+)\s+\(\s*([0-9$,.]+)\s*\),?\s+is\s+sitting\s+out$/i then
              @game.add_player :name => $2, :seat => $1.to_i, :chips => cash_to_d($3)
            when /^(.*)\s+antes\s+(#{CASH})/i then
              @game.add_event(:kind => 'ante', :amount => cash_to_d($2), :player => $1)
            when /(.*)\s+posts\s+(a dead|the)\s+(small|big)\s+blind\s+of\s+(#{CASH})/i then
              @game.add_event(:kind => $3, :amount => cash_to_d($4), :player => $1)
            when /^(.*)\s+posts\s+(#{CASH})$/i then
              @game.add_event(:kind => 'ante', :amount => cash_to_d($3), :player => $1)
            when /^The\s+button\s+is\s+in\s+seat\s+\#(\d+)/i then
              @game.update :button_seat => $1.to_i
            when /\*+\s+HOLE\s+CARDS\s+\*+/i then
              @game.add_action(:kind => 'preflop')
            when /^Dealt\s+to\s+(\w+)\s+\[([^\]]+)\]/i then
              @game.dealt($1, $2)
            when /(.+)\s+(calls|bets)\s+(#{CASH})/i then
              @game.add_event(:kind => $2, :player => $1, :amount => cash_to_d($3))
            when /(.+)\s+(folds|checks)/ then
              @game.add_event(:kind => $2, :player => $1)
            when /(.+)\s+raises\s+to\s+(#{CASH})/i then
              @game.add_event(:kind => 'raises', :player => $1, :amount => cash_to_d($2))
            when /\*+\s+Flop\s+\*+\s+\[(.*)\]/i then
              @game.add_action(:kind => 'flop', :cards => $1)
            when /Uncalled\s+bet\s+of\s+(#{CASH})\s+returned\s+to\s+(.*)/i then
              # TODO:
            when /Board:\s+\[(.*)\]/ then
              @game.update :board => $1
            when /^(.*)\s+mucks/ then
              @game.add_event(:kind => 'mucks', :player => $1)
            when /^(.*)\s+wins\s+the\s+(side\s+|main\s+)?pot\s+\((#{CASH})\)/ then
              @game.add_event(:kind => 'wins', :player => $1, :amount => cash_to_d($3))
            when /\*+\s+SUMMARY\s+\*+/i then
            when /\*+\s+TURN\s+\*+\s+\[(.*)\]\s+\[(.*)\]/i then
              @game.add_action(:kind => 'turn', :cards => $2)
            when /\*+\s+RIVER\s+\*+\s+\[(.*)\]\s+\[(.*)\]/i then
              @game.add_action(:kind => 'river', :cards => $2)
            when /\*+\s+SHOW\s+DOWN\s+\*+/i then
              @game.add_action(:kind => 'showdown')
            when /^(.*)\s+shows\s+\[([^\]]*)\]/i, /^(.*)\s+shows\s+(.*)$/i then
              @game.add_event(:kind => 'shows', :player => $1, :cards => $2)
            when /Total\s+pot\s+(#{CASH})\s+(((Main)|(Side))\s+pot(-[0-9]+)?\s+(#{CASH}).)*\|\s+Rake\s+(#{CASH})/i then
              @game.update :total_pot => cash_to_d($1), :rake => cash_to_d($8)
            when /Total\s+pot\s+(#{CASH})(\s+(Main|Side)\s+pot(\s+#{CASH})?\s+(#{CASH})\.)*\s+\|\s+Rake\s+(#{CASH})/i then
              @game.update :total_pot => cash_to_d($1), :rake => cash_to_d($6)
            when /(.*)\s+wins\s+the\s+pot\s+\((#{CASH})\)/i, /^(.*)\s+ties\s+for\s+the\s+((main|side)\s+)?pot\s+\((#{CASH})\)/i then
              @game.add_event(:kind => 'wins', :player => $1, :amount => cash_to_d($2))
            when /(.*)\s+wins\s+(the|side)\s+pot\s+(#\d+\s+)?\((#{CASH})\)/ then
              @game.add_event(:kind => 'wins', :player => $1, :amount => cash_to_d($4))
            when /^(.*)\s+adds\s+(#{CASH})/i then
            when /Seat\s+[0-9]+:\s+(.*)\s+(\((small blind)|(big blind)|(button)\) )?showed\s+\[([^\]]+)\]\s+and\s+((won)\s+\(#{CASH}\)|(lost))/i then
            when /^(.*):\s+easy\s+call$/ then
              #TODO:
            when /^Ante\s+of\s+(#{CASH})\s+returned\s+to\s+(.*)$/ then
              #TODO:
            when /^(.*):\s+(.*)$/i then
              raise ParseError.new("#{room_name} invalid line for parse: #{line}") unless @game.has_player?($1) || ignorable?(line)
            else
              raise ParseError.new("#{room_name} invalid line for parse: #{line}") unless ignorable?(line)
          end
        end
        
        def determine_game(source)
          case source
            when /Hold\'em/i, /Холдем/i then 'HE'
            when /Omaha\s+Hi\/Lo/i, /Омаха/i then 'OH'
            when /7\sCard\sStud\sHi\/Lo/i then '7S'
          end
        end
        
        def ignorable?(line)
          regular_expressions_for_ignorable_phrases = [
            /(.*) has timed out/,
            /(.*) has returned/,
            /(.*) leaves the table/,
            /(.*) joins the table at seat #[0-9]+/,
            /(.*) sits out/,
            /(.*) is sitting out/,    
            /(.*) is (dis)?connected/,
            /(.*)\s+has\s+been\s+(dis)?connected/i,
            /(.*)\s+has\s+\d+\s+second(s)?\s+to\s+(re)?connect/i,
            /(.*)\s+has\s+(re)?connected/i,
            /(.*)\s+stands\s+up/i,
            /(.*) said,/, 
            /(.*): doesn't show hand/,        
            /(.*) will be allowed to play after the button/,
            /(.*) was removed from the table for failing to post/,
            /(.*) re-buys and receives (.*) chips for (.*)/,
            /(.*)\s+has\s+\d+\s+seconds\s+left\s+to\s+act/i,
            /(.*):\s+chasing\s+fool/i,
            /^(.*)\s+has\s+(requested|registered)/i,
            /(.*)\s+sits\s+down/i,
            /^Hand\s+\#\d+\s+has\s+been\s+canceled/,
            /^(.*)\s+is\s+feeling\s+(happy|confused|angry|normal)/,
            /^Time\s+has\s+expired/,
            /Seat\s+\d+:\s+(.*)\s+didn't\s+(bet|raise)/,
            /Seat [0-9]+: (.*) \(((small)|(big)) blind\) folded on the Flop/,
            /Seat\s+\d+\:\s+(.*)\s+\(((small)|(big)) blind\)$/,
            /Seat [0-9]+: (.*) folded on the ((Flop)|(Turn)|(River))/,
            /Seat [0-9]+: (.*) folded before Flop \(didn't bet\)/,
            /Seat\s+[0-9]+:\s+(.*)\s+(\((small blind)|(big blind)|(button)\)\s+)?folded\s+before\s+(the\s+)?Flop( \(didn't bet\))?/,
            /Seat [0-9]+: (.*) (\((small blind)|(big blind)|(button)\) )?collected (.*)/,
            /Seat\s+\d+:\s+(.*)\s+(button\s+)?mucked\s+/,
            /Seat\s+\d+:\s+(.*)\s+is\s+sitting\s+out/,
            /^Seat\s+\d+\:\s+(.*)\s+\(button\)/,
            /^\d+\s+second(s)?\s+left\s+to\s+act/,
            /^(.*)\s+\(Observer\)\:\s+(.*)$/i,
            /^\s*$/
          ]
          regular_expressions_for_ignorable_phrases.any?{|re| re =~ line }
        end
    end
  end
end

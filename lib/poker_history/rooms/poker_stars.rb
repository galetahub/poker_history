module PokerHistory
  module Rooms
    class PokerStars < Base
      
      def room_name
        'PokerStars'
      end
      
      protected
      
        def parse_line(line)
          case line
          when /PokerStars Game #([0-9]+): Tournament #([0-9]+), (#{CASH})\+(#{CASH}) Hold'em (Pot |No |)Limit - Level ([IVXL]+) \((#{CASH})\/(#{CASH})\) - (.*)$/
            @game.update(:title => "PS#{$1}", 
              :date => Utils::TimeStringConverter.new($9).as_utc_datetime, 
              :description => "#{$2}, #{$3}+#{$4} Hold'em #{$5}Limit", 
              :tournament => $2, :stakes_type => cash_to_d($3), :limit => parse_limit_type($5),
              :blinds_amounts => {:sb=> $7.to_f, :bb=> $8.to_f, :ante => 0.0} )
            
            #@stats.update_hand :name => "PS#{$1}", :description=> "#{$2}, #{$3}+#{$4} Hold'em #{$5}Limit", :tournament=> $2, 
            #    :sb=> $7.to_f, :bb=> $8.to_f, :ante => "0.0".to_f, 
            #    :played_at=> PokerstarsTimeStringConverter.new($9).as_utc_datetime,
            #    :street => :prelude, :board => "", :max_players => 0, :number_players => 0, :table_name => "",
            #    :game_type => "Hold'em", :limit_type => "#{$5}Limit", :stakes_type => cash_to_d($3)
          when /PokerStars Game #([0-9]+): Tournament #([0-9]+), (Freeroll|(#{CASH})\+(#{CASH}) *(USD)?) +Hold'em (Pot |No |)Limit -.*Level ([IVXL]+) \((#{CASH})\/(#{CASH})\) - (.*)$/
            @game.update :title => "PS#{$1}", :description => "#{$2}, #{$3} Hold'em #{$7}Limit", :tournament => $2,
              :date => Utils::TimeStringConverter.new($11).as_utc_datetime, :stakes_type => cash_to_d($4),
              :limit => parse_limit_type($7), :blinds_amounts => { :sb=> $9.to_f, :bb=> $10.to_f, :ante => 0.0 }
              
            #@stats.update_hand :name => "PS#{$1}", :description=> "#{$2}, #{$3} Hold'em #{$7}Limit", :tournament=> $2, 
            #    :sb=> $9.to_f, :bb=> $10.to_f, :ante => "0.0".to_f, 
            #    :played_at=> PokerstarsTimeStringConverter.new($11).as_utc_datetime,
            #    :street => :prelude, :board => "", :max_players => 0, :number_players => 0, :table_name => "",
            #    :game_type => "Hold'em", :limit_type => "#{$7}Limit", :stakes_type => cash_to_d($4)            
          when /PokerStars Game #([0-9]+): Tournament #([0-9]+), (Freeroll|(#{CASH}).*(FPP)) *(USD)? +Hold'em (Pot |No |)Limit -.*Level ([IVXL]+) \((#{CASH})\/(#{CASH})\) - (.*)$/
            @game.update :title => "PS#{$1}", :description=> "#{$2}, #{$3} Hold'em #{$7}Limit", :tournament=> $2,
              :date => Utils::TimeStringConverter.new($11).as_utc_datetime, :limit => parse_limit_type($7),
              :blinds_amounts => { :sb=> $9.to_f, :bb=> $10.to_f, :ante => 0.0 }
            
            #@stats.update_hand :name => "PS#{$1}", :description=> "#{$2}, #{$3} Hold'em #{$7}Limit", :tournament=> $2, 
            #    :sb=> $9.to_f, :bb=> $10.to_f, :ante => "0.0".to_f, 
            #    :played_at=> PokerstarsTimeStringConverter.new($11).as_utc_datetime,
            #    :street => :prelude, :board => "", :max_players => 0, :number_players => 0, :table_name => "",
            #    :game_type => "Hold'em", :limit_type => "#{$7}Limit", :stakes_type => "0".to_f
          when /PokerStars Game #([0-9]+): +([^(]*)Hold'em (No |Pot |)Limit \((#{CASH})\/(#{CASH})\) - (.*)$/
            @game.update :title => "PS#{$1}", :description=> "#{$2}Hold'em #{$3}Limit (#{$4}/#{$5})",
              :date => Utils::TimeStringConverter.new($6).as_utc_datetime, :stakes_type => cash_to_d($5),
              :limit => parse_limit_type($3),
              :blinds_amounts => { :sb=> cash_to_d($4), :bb=> cash_to_d($5), :ante => 0.0 }
            
            #@stats.update_hand :name => "PS#{$1}", :description=> "#{$2}Hold'em #{$3}Limit (#{$4}/#{$5})", :tournament=> nil, 
            #    :sb=> cash_to_d($4), :bb=> cash_to_d($5), :ante => "0.0".to_f, 
            #    :played_at=> PokerstarsTimeStringConverter.new($6).as_utc_datetime,
            #    :street => :prelude, :board => "", :max_players => 0, :number_players => 0, :table_name => "",
            #    :game_type => "Hold'em", :limit_type => "#{$3}Limit", :stakes_type => cash_to_d($5)
          when /PokerStars Game #([0-9]+): +([^(]*)Hold'em (No |Pot |)Limit \((#{CASH})\/(#{CASH}) USD\) - (.*)$/
            @game.update :title => "PS#{$1}", :description=> "#{$2}Hold'em #{$3}Limit (#{$4}/#{$5})",
              :date => Utils::TimeStringConverter.new($6).as_utc_datetime, :stakes_type => cash_to_d($5),
              :limit => parse_limit_type($3),
              :blinds_amounts => { :sb=> cash_to_d($4), :bb=> cash_to_d($5), :ante => 0.0 }
            
            #@stats.update_hand :name => "PS#{$1}", :description=> "#{$2}Hold'em #{$3}LImit (#{$4}/#{$5})", :tournament=> nil, 
            #    :sb=> cash_to_d($4), :bb=> cash_to_d($5), :ante => "0.0".to_f, 
            #    :played_at=> PokerstarsTimeStringConverter.new($6).as_utc_datetime,
            #    :street => :prelude, :board => "", :max_players => 0, :number_players => 0, :table_name => "",
            #    :game_type => "Hold'em", :limit_type => "#{$3}Limit", :stakes_type => cash_to_d($5)
          when /PokerStars\s+Game\s+\#(\d+)\:\s+Omaha\s+(No |Pot |)Limit\s+\(([0-9,.$]+)\/([0-9,.$]+)\s+USD\)\s+-\s+(.*)$/ then
            @game.update :title => "PS#{$1}", :description=> "Omaha #{$2}Limit (#{$3}/#{$4})",
              :date => Utils::TimeStringConverter.new($5).as_utc_datetime, :stakes_type => cash_to_d($4),
              :limit => parse_limit_type($2),
              :blinds_amounts => { :sb=> cash_to_d($3), :bb=> cash_to_d($4), :ante => 0.0 }
          when /PokerStars Game #([0-9]+):/
            raise ParseError, "invalid hand record: #{line}"
          when /\*\*\* HOLE CARDS \*\*\*/
            @game.add_action(:kind => 'preflop')
            #@stats.register_button(@stats.button)
            #@stats.update_hand :street => :preflop
          when /\*\*\* FLOP \*\*\* \[(.*)\]/
            @game.add_action(:kind => 'flop', :cards => $1)
            #@stats.update_hand :street => :flop
          when /\*\*\* TURN \*\*\* \[([^\]]*)\] \[([^\]]*)\]/
            @game.add_action(:kind => 'turn', :cards => $2)
            #@stats.update_hand :street => :turn
          when /\*\*\* RIVER \*\*\* \[([^\]]*)\] \[([^\]]*)\]/
            @game.add_action(:kind => 'river', :cards => $2)
            #@stats.update_hand :street => :river
          when /\*\*\* SHOW DOWN \*\*\*/
            @game.add_action(:kind => 'showdown')
            #@stats.update_hand :street => :showdown
          when /\*\*\* SUMMARY \*\*\*/
            #@game.add_action(:kind => 'summary')
            #@stats.update_hand :street => :summary
          when /Dealt to ([^)]+) \[([^\]]+)\]/
            @game.dealt($1, $2)
            #@stats.register_action($1, 'dealt', :result => :cards, :data => $2)
          when /(.*): shows \[(.*)\]/
            @game.add_event(:kind => 'shows', :player => $1, :cards => $2)
            #@stats.register_action($1, 'shows', :result => :cards, :data => $2)
          when /Board \[(.*)\]/
            @game.update :board => $1
            #@stats.update_hand :board => $1
          when /Total pot (#{CASH}) (((Main)|(Side)) pot(-[0-9]+)? (#{CASH}). )*\| Rake (#{CASH})/
            @game.update :total_pot => cash_to_d($1), :rake => cash_to_d($8)
            #@stats.update_hand(:total_pot => cash_to_d($1), :rake => cash_to_d($8))
          when /Total pot (#{CASH}) Main pot (#{CASH}).( Side pot-[0-9]+ (#{CASH}).)* | Rake (#{CASH})/
            raise ParseError, "popo!"
          when /Seat ([0-9]+): (.+) \((#{CASH}) in chips\)( is sitting out)?/
            @game.add_player(:name => $2, :seat => $1.to_i, :chips => cash_to_d($3))
          when /(.*): posts (small|big|small\s\&\sbig) blind(s)? (#{CASH})/
            @game.add_event(:kind => $2, :amount => cash_to_d($4), :player => $1)
            #@stats.register_action($1, 'posts', :result => :post, :amount => cash_to_d($7))
          when /(.*): posts the ante (#{CASH})/
            @game.add_event(:kind => 'ante', :amount => cash_to_d($2), :player => $1)
            #@stats.register_action($1, 'antes', :result => :post, :amount => cash_to_d($2))
            #@stats.update_hand(:ante => [cash_to_d($2), @stats.hand_information(:ante)].max)
          # when /Table '([0-9]+) ([0-9]+)' ([0-9]+)-max Seat #([0-9]+) is the button/
          #   @stats.register_button($4.to_i)
          when /Table '(.*)' ([0-9]+)-max Seat #([0-9]+) is the button/
            @game.update :table_name => $1, :max_players => $2.to_i, :button_seat => $3.to_i
          when /Uncalled bet \((.*)\) returned to (.*)/
            #@game.add_event(:kind => 'wins', :player => $2, :amount => cash_to_d($1))
            #@stats.register_action($2, 'return', :result => :win, :amount => cash_to_d($1))
          when /(.+): (folds|checks)/
            @game.add_event(:kind => $2, :player => $1)
            #@stats.register_action($1, $2, :result => :neutral)
          when /(.+): (calls|bets) ((#{CASH})( and is all-in)?)?$/
            @game.add_event(:kind => $2, :player => $1, :amount => cash_to_d($4))
            #@stats.register_action($1, $2, :result => :pay, :amount => cash_to_d($6))
          when /(.+): raises (#{CASH}) to (#{CASH})( and is all-in)?$/
            @game.add_event(:kind => 'raises', :player => $1, :amount => cash_to_d($3))
            #@stats.register_action($1, 'raises', :result => :pay_to, :amount => cash_to_d($3))
          when /(.*) collected (.*) from ((side )|(main ))?pot/
            @game.add_event(:kind => 'wins', :player => $1, :amount => cash_to_d($2))
            #@stats.register_action($1, "wins", :result => :win, :amount => cash_to_d($2))
          when /(.*): doesn't show hand/ then 
            @game.add_event(:kind => 'not_show', :player => $1)
          when /(.*): mucks hand/
            @game.add_event(:kind => 'mucks', :player => $1)
            #@stats.register_action($1, 'mucks', :result => :neutral)
          when /Seat [0-9]+: (.*) (\((small blind)|(big blind)|(button)\) )?showed \[([^\]]+)\] and ((won) \(#{CASH}\)|(lost)) with (.*)/ then
          when /Seat [0-9]+: (.*) mucked \[([^\]]+)\]/ then
          
          # Russian
          when /Игра\s+PokerStars\s+#([0-9]+):\s+Турнир\s+№([0-9]+),\s+(#{CASH})\+(#{CASH})\s+Холдем\s+(Безлимитный|Лимит|Пот\-лимит)\s+\-\s+уровень\s+([IVXL]+)\s+\((#{CASH})\/(#{CASH})\)\s+\-\s+(.*)$/ then
            @game.update :title => "PS#{$1}", :description => "#{$2}, #{$3}+#{$4} Холдем #{$5}", :tournament => $2,
              :date => Utils::TimeStringConverter.new($9).as_utc_datetime, :stakes_type => cash_to_d($8),
              :blinds_amounts => { :sb=> $7.to_f, :bb=> $8.to_f, :ante => 0.0 },
              :limit => parse_limit_type($5)
          when /Игра\s+PokerStars\s+#([0-9]+):\s+Турнир\s+№([0-9]+)\,\s+(#{CASH})\+(#{CASH})\s+(USD\s+)?Холдем\s+(Безлимитный|Лимит|Пот\-лимит)\s+\-\s+(Раунд\s+матча\s+[IVXL]+\,\s+)?уровень\s+([IVXL]+)\s+\((#{CASH})\/(#{CASH})\)\s+\-\s+(.*)$/i then
            @game.update :title => "PS#{$1}", :description => "#{$2}, #{$3}+#{$4} Холдем #{$6} #{$7} уровень #{$8}", 
              :tournament => $2,
              :date => Utils::TimeStringConverter.new($11).as_utc_datetime, :stakes_type => cash_to_d($10),
              :blinds_amounts => { :sb=> $9.to_f, :bb=> $10.to_f, :ante => 0.0 },
              :limit => parse_limit_type($6)
          when /Игра\s+PokerStars\s+#([0-9]+):\s+Турнир\s+№([0-9]+)\,\s+(#{CASH})\+(#{CASH})\s+(USD\s+)?(\d+)\-Game\s+(.+)\s+\-\s+уровень\s+([IVXL]+)\s+\((#{CASH})\/(#{CASH})\)\s+\-\s+(.*)$/i then
            @game.update :title => "PS#{$1}", :description => "#{$2}, #{$3}+#{$4} #{$6}-Game #{$7} - уровень #{$8}", 
              :tournament => $2,
              :date => Utils::TimeStringConverter.new($11).as_utc_datetime, :stakes_type => cash_to_d($10),
              :blinds_amounts => { :sb=> $9.to_f, :bb=> $10.to_f, :ante => 0.0 }
          when /Игра\s+PokerStars\s+#([0-9]+)\s?:\s+Холдем\s+(Безлимитный|Лимит|Пот\-лимит) \((#{CASH})\/(#{CASH})\)\s+-\s+(.*)$/ then
            @game.update :title => "PS#{$1}", :description => "Холдем #{$2}",
              :date => Utils::TimeStringConverter.new($5).as_utc_datetime, :stakes_type => cash_to_d($4),
              :blinds_amounts => { :sb=> $3.to_f, :bb=> $4.to_f, :ante => 0.0 },
              :limit => parse_limit_type($2)
          when /Игра\s+PokerStars\s+#([0-9]+)\s?:\s+Холдем\s+(Безлимитный|Лимит|Пот\-лимит)\s+\((#{CASH})\/(#{CASH})\s+USD\)\s+\-\s+(.*)$/
            @game.update :title => "PS#{$1}", :description => "Холдем #{$2}",
              :date => Utils::TimeStringConverter.new($5).as_utc_datetime, :stakes_type => cash_to_d($4),
              :blinds_amounts => { :sb=> $3.to_f, :bb=> $4.to_f, :ante => 0.0 },
              :limit => parse_limit_type($2)
          when /Стол\s+'(.*)'\s+([0-9]+)-max\s*(.*)?Баттон\s+на\s+месте\s+№\s?([0-9]+)/ then
            @game.update :table_name => $1, :max_players => $2.to_i, :button_seat => $4.to_i
          when /^Место\s+([0-9]+)\s*:\s+(.+)\s+\(\s?(#{CASH})\s?\)$/ then
            @game.add_player(:name => $2, :seat => $1.to_i, :chips => cash_to_d($3))
          when /^Место\s+([0-9]+)\s*:\s+(.+)\s+\(\s?(#{CASH})\s?\)\s+пропускает$/ then
            @game.add_player(:name => $2, :seat => $1.to_i, :chips => cash_to_d($3))
          when /(.*):\s+ставит\s+(малый|большой|малый\sи\sбольшой)\s+блайнд(ы)?\s+(#{CASH})/ then         
            @game.add_event(:kind => parse_event_kind($2), :amount => cash_to_d($4), :player => $1)
          when /\*+\s+ЗАКРЫТЫЕ\s+КАРТЫ\s+\*+/i then
            @game.add_action(:kind => 'preflop')
          when /Карты\s+([^)]+)\s+\[([^\]]+)\]/ then 
            @game.dealt($1, $2)
          when /(.+):\s+делает\s+(колл|бет)\s+(#{CASH})\s?(и олл-ин)?/i then
            kind = $4.blank? ? $2 : 'all-in'
            @game.add_event(:kind => parse_event_kind(kind), :player => $1, :amount => cash_to_d($3))
          when /\*+\s+ФЛОП\s+\*+\s+\[(.*)\]/i then
            @game.add_action(:kind => 'flop', :cards => $1)
          when /(.+):\s+делает\s+(фолд|чек)/ then
            @game.add_event(:kind => parse_event_kind($2), :player => $1)
          when /\*+\s+ТЕРН\s+\*+\s+\[([^\]]*)\] \[([^\]]*)\]/i then
            @game.add_action(:kind => 'turn', :cards => $2)
          when /(.+):\s+делает\s+рейз\s+(#{CASH})\s+(#{CASH})\s?(и олл-ин)?/i then
            @game.add_event(:kind => 'raises', :player => $1, :amount => cash_to_d($2))
          when /(.*)\:\s+ставит\s+анте\s+(#{CASH})/
            @game.add_event(:kind => 'ante', :amount => cash_to_d($2), :player => $1)
          when /\*+\s+РИВЕР\s+\*+\s+\[([^\]]*)\]\s+\[([^\]]*)\]/i then
            @game.add_action(:kind => 'river', :cards => $2)
          when /\*+\s+ВСКРЫТИЕ\s+КАРТ\s+\*+/i then
            @game.add_action(:kind => 'showdown')
          when /(.*):\s+открывает\s+\[([^\]]*)\]\s+(.*)?/i then
            @game.add_event(:kind => 'shows', :player => $1, :cards => $2)
          when /(.*)\s+получил\s+(.*)\s+из\s+(главный|побочный)?\s?банка/i then
            @game.add_event(:kind => 'wins', :player => $1, :amount => cash_to_d($2))
          when /^Игрок\s+(.*)\s+побеждает\s+в\s+турнире\s+и\s+получает\s+(#{CASH})/i then
            @game.add_event(:kind => 'wins', :player => $1, :amount => cash_to_d($2))
          when /\*+\s+ИТОГ\s+\*+/i then
          when /Общий\s+банк\s+(#{CASH})\s+((Главный|Побочный)\s+банк(-[0-9]+)?\s+(#{CASH}).\s+)*\|\s+Доля\s+(#{CASH})/ then
            @game.update :total_pot => cash_to_d($1), :rake => cash_to_d($6)
          when /Борд\s+\[(.*)\]/i then
            @game.update :board => $1
          when /Место\s+[0-9]+:\s+(.*)\s+(\(малый блайнд|большой блайнд|баттон\)\s+)?открыл\s+\[([^\]]+)\]\s+и\s+((выиграл)\s+\(#{CASH}\)|(проиграл))\s+(.*)/i then
          when /^Место\s+\d+:\s+(.*)\s+сбросил\s+\[([^\]]+)\]/i then
          when /^Неуравненная\s+ставка\s+\((.*)\)\s+возвращается\s+игроку\s+(.*)/i then
          when /(.*)\s?:\s+не\s+показывает\s+руку/i then 
            @game.add_event(:kind => 'not_show', :player => $1)
          
          # Лоуболл
          when /\*+\s+СДАЧА\s+КАРТ\s+\*+/ then
            @game.add_action(:kind => 'preflop')
          when /\*+\s+(\w+)\s+ОБМЕН\s+\*+/i then
            @game.add_action(:kind => 'exchange')
          when /(.+):\s+сбрасывает\s+(\d+)\s+карт(ы|a)?/i then
            @game.add_event(:kind => 'reset', :player => $1, :cards_count => $2)
          when /(.+):\s+не\s+меняет\s+карт/ then
            @game.add_event(:kind => 'noreset', :player => $1)
          when /^Место\s+\d+:\s+(.*)\s+сделал\s+(фолд)\s+(до|после)/ then
          when /^Колода\s+перетасовывается$/i then
          when /^Нет\s+нижней\s+комбинации$/i then
          else
            raise ParseError, "#{room_name} invalid line for parse: #{line}." unless ignorable?(line)
          end
        end
        
        def determine_game(source)
          case source
            when /Hold\'em/i, /Холдем/i then 'HE'
            when /Omaha\s+Hi\/Lo/i, /Омаха/i, /Omaha/ then 'OH'
            when /7\sCard\sStud\sHi\/Lo/i then '7S'
          end
        end
        
        def ignorable?(line)
          regular_expressions_for_ignorable_phrases = [
            /(.*) has timed out/,
            /^время\s+на\s+ход\s+игрока\s+(.*)\s+истекло/,
            /(.*) has returned/,
            /(.*)\s?:\s+пропускает/,
            /(.*) leaves the table/,
            /^(.*)\s+покидает\s+стол\s?$/i,
            /(.*) joins the table at seat #[0-9]+/,
            /(.*)\s+садится\s+за\s+стол\s+на\s+место\s+.\d+/i,
            /(.*) sits out/,
            /(.*) is sitting out/,
            /^(.*)\s?:\s+сбрасывает\s+руку\s?$/i,
            /(.*) is (dis)?connected/,
            /(.*)\s+отключен/,
            /(.*)\s+на\s+связи/,
            /(.*) said,/,
            /(.*)\s+сказал,/i,
            /(.*) will be allowed to play after the button/,
            /(.*)\s+сможет\s+играть\s+после\s+баттона/i,
            /(.*) was removed from the table for failing to post/,
            /(.*)\s+выведен\s+из\-за\s+стола\s+из\-за\s+отсутствия\s+ставки/,
            /(.*) re-buys and receives (.*) chips for (.*)/,
            /^достигнут\s+лимит\s+ставок/,
            /Seat [0-9]+: (.*) \(((small)|(big)) blind\) folded on the Flop/,
            /Место\s+[0-9]+:\s+(.*)\s+\((малый|большой)\s+блайнд\)\s+сделал\s+фолд\s+на\s+Флоп/i,
            /Seat [0-9]+: (.*) folded on the ((Flop)|(Turn)|(River))/,
            /Место\s+[0-9]+:\s+(.*)\s+сделал\s+фолд\s+(на|до)\s+(Флоп|Терн|Ривер)/i,
            /Seat [0-9]+: (.*) folded before Flop \(didn't bet\)/,
            /Seat [0-9]+: (.*) (\((small blind)|(big blind)|(button)\) )?folded before Flop( \(didn't bet\))?/,
            /Seat [0-9]+: (.*) (\((small blind)|(big blind)|(button)\) )?collected (.*)/,
            /^Место\s+[0-9]+:\s+(.*)\s+не\s+участвует\s+в\s+раздаче/,
            /^игрок\s+(.*)\s+занял\s+в\s+турнире\s+\d+/i,
            /^Игрок\s+(.*)\s+занимает\s+в\s+турнире\s+\d+/i,
            /(.*)\s+пропускает$/,
            /игрок\s+(.*)\s+вернулся$/i,
            /^\s*$/
          ]
          
          regular_expressions_for_ignorable_phrases.any?{|re| re =~ line }
        end
    end
  end
end

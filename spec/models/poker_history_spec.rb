require 'spec_helper'

describe PokerHistory do

  context "poker stars" do
    before(:all) do
      @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'pokerstars.txt') )
      @parser = PokerHistory.parse(@source)
      @game = @parser.game
    end
    
    it "should parse game title" do
      @game.title.should == 'PS27239832332'
      @game.kind.should == 'HE'
      @game.limit_kind.should == 'UltrahighLimits'
    end
    
    it "should parse game date" do
      @game.date.to_s.should == '2009-04-18T22:59:23+00:00'
    end
    
    it "should parse game table_name" do
      @game.table_name.should == '156906452 6'
    end
    
    it "should parse game total_pot" do
      @game.total_pot.should == 3950
    end
    
    it "should parse game rake" do
      @game.rake.should == 0
    end
    
    it "should parse game max_players" do
      @game.max_players.should == 9
    end
    
    it "should parse game blinds_amounts" do
      @game.blinds_amounts.should == { :sb => 200.0, :bb => 400.0, :ante => 50.0 } 
    end
    
    it "should parse game description" do
      @game.description.should == "156906452, $8.00+$0.80 Hold'em No Limit"
    end
    
    it "should parse game button_seat" do
      @game.button_seat.should == 6
    end
    
    it "should parse game board" do
      @game.board.should == ['Kc', '8h', 'Kh', '9c', 'Jd']
    end
    
    it "should parse game stakes_type" do
      @game.stakes_type.should == 8.0
    end
    
    it "should parse game tournament" do
      @game.tournament.should == '156906452'
    end
    
    it "should parse game limit" do
      @game.limit.should == 'NL'
    end
    
    it "should parse game kind" do
      @game.kind.should == 'HE'
    end
    
    it "should parse game players" do
      @game.players_count.should == 7
      
      @game.players[0].seat.should == 1
      @game.players[0].name.should == 'delvo 01'
      @game.players[0].chips.should == 16375
      @game.players[0].kind.should == 'default'
      
      @game.players[1].seat.should == 2
      @game.players[1].name.should == 'joe1941'
      @game.players[1].chips.should == 7860
      @game.players[1].kind.should == 'default'
      
      @game.players[2].seat.should == 5
      @game.players[2].name.should == 'rchdot'
      @game.players[2].chips.should == 48360
      @game.players[2].kind.should == 'default'
      
      @game.players[3].seat.should == 6
      @game.players[3].name.should == 'jutro7'
      @game.players[3].chips.should == 14331
      @game.players[3].kind.should == 'dealer'
      
      @game.players[4].seat.should == 7
      @game.players[4].name.should == 'fredmonster9'
      @game.players[4].chips.should == 9180
      @game.players[4].kind.should == 'small_blind'
      
      @game.players[5].seat.should == 8
      @game.players[5].name.should == 'situationist'
      @game.players[5].chips.should == 18057
      @game.players[5].kind.should == 'big_blind'
      @game.players[5].cards.should == ['8d', 'Ts']
      @game.players[5].hero.should be_true
      
      @game.players[6].seat.should == 9
      @game.players[6].name.should == 'Pla8Net'
      @game.players[6].chips.should == 13768
      @game.players[6].kind.should == 'default'
    end
    
    it "should parse game actions" do
      @game.actions.size.should == 5
      @game.actions[0].kind.should == 'preflop'
      @game.actions[0].cards.should be_nil
      @game.actions[0].previous_pot.should == 950
      @game.initial_pot_size.should == 950
      @game.events.map(&:amount).compact.sum.should == 950
      
      @game.actions[1].kind.should == 'flop'
      @game.actions[1].cards.should == ['Kc', '8h', 'Kh']
      @game.actions[1].players_count.should == 3
      @game.actions[1].previous_pot.should == 1550.0
      @game.actions[1].total_pot.should == 1550
      
      @game.actions[2].kind.should == 'turn'
      @game.actions[2].cards.should == ['9c']
      @game.actions[2].players_count.should == 3
      @game.actions[2].previous_pot.should == 1550.0
      @game.actions[2].total_pot.should == 2350
      
      @game.actions[3].kind.should == 'river'
      @game.actions[3].cards.should == ['Jd']
      @game.actions[3].players_count.should == 2
      @game.actions[3].previous_pot.should == 2350.0
      @game.actions[3].total_pot.should == 3950
      
      @game.actions[4].kind.should == 'showdown'
      @game.actions[4].previous_pot.should == 3950.0
    end
    
    it "should parse game status" do
      @game.hero.stake.should == 1650.0
      
      @game.players[5].should == @game.hero
      @game.players[3].stake.should == 1650.0
      @game.players[3].winner.should be_true
      @game.players[3].sum.should == 3950
    end
  end
  
  context "party poker" do
    before(:all) do
      @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'partypoker.txt') )
      @parser = PokerHistory.parse(@source)
      @game = @parser.game
    end
    
    it "should parse game title" do
      @game.title.should == 'PP4585599791'
      @game.kind.should == 'HE'
      @game.limit_kind.should == 'LowLimits'
    end
    
    it "should parse game date" do
      @game.date.to_s.should == '2006-06-24T23:22:50+00:00'
    end
    
    it "should parse game table_name" do
      @game.table_name.should == 'Start Time (Real Money)'
    end
    
    it "should parse game total_pot" do
      @game.total_pot.should == 37.15
    end
    
    it "should parse game rake" do
      @game.rake.should == 0
    end
    
    it "should parse game max_players" do
      @game.max_players.should == 10
    end
    
    it "should parse game blinds_amounts" do
      @game.blinds_amounts.should == { :sb => 0.10, :bb => 0.25, :ante => 0.0 } 
    end
    
    it "should parse game description" do
      @game.description.should be_nil
    end
    
    it "should parse game button_seat" do
      @game.button_seat.should == 5
    end
    
    it "should parse game board" do
      @game.board.should == ['8h', '7s', '5s', '6c', '3s']
    end
    
    it "should parse game stakes_type" do
      @game.stakes_type.should == 25.0
    end
    
    it "should parse game tournament" do
      @game.tournament.should be_nil
    end
    
    it "should parse game players" do
      @game.players_count.should == 10
      
      @game.players[0].seat.should == 1
      @game.players[0].name.should == 'kalimeroo'
      @game.players[0].chips.should == 17.65
      @game.players[0].kind.should == 'default'
      
      @game.players[1].seat.should == 8
      @game.players[1].name.should == 'h0lden2Aces'
      @game.players[1].chips.should == 25.10
      @game.players[1].kind.should == 'default'
      
      @game.players[2].seat.should == 2
      @game.players[2].name.should == 'MadeInUSSR'
      @game.players[2].chips.should == 28.70
      @game.players[2].kind.should == 'default'
      @game.players[2].cards.should == ["Kd", "Kh"]
      @game.players[2].hero.should be_true
      
      @game.players[3].seat.should == 9
      @game.players[3].name.should == 'alladin123'
      @game.players[3].chips.should == 8.85
      @game.players[3].kind.should == 'default'
      
      @game.players[4].seat.should == 5
      @game.players[4].name.should == 'Rcoffman4'
      @game.players[4].chips.should == 18.36
      @game.players[4].kind.should == 'dealer'
      
      @game.players[5].seat.should == 6
      @game.players[5].name.should == 'luckyj_666'
      @game.players[5].chips.should == 23.70
      @game.players[5].kind.should == 'small_blind'
      
      @game.players[6].seat.should == 10
      @game.players[6].name.should == 'mrspikester1'
      @game.players[6].chips.should == 25.95
      @game.players[6].kind.should == 'default'
      
      @game.players[7].seat.should == 7
      @game.players[7].name.should == 'bc_junior'
      @game.players[7].chips.should == 26.05
      @game.players[7].kind.should == 'big_blind'
      
      @game.players[8].seat.should == 3
      @game.players[8].name.should == 'ihavetwodads'
      @game.players[8].chips.should == 24
      @game.players[8].kind.should == 'default'
      
      @game.players[9].seat.should == 4
      @game.players[9].name.should == 'vegas1225'
      @game.players[9].chips.should == 25.35
      @game.players[9].kind.should == 'default'
    end
    
    it "should parse game actions" do
      @game.actions.size.should == 4
      @game.actions[0].kind.should == 'preflop'
      @game.actions[0].cards.should be_nil
      @game.actions[0].previous_pot.should == 0.35
      @game.initial_pot_size.should == 0.35
      
      @game.actions[1].kind.should == 'flop'
      @game.actions[1].cards.should == ["8h", "7s", "5s"]
      @game.actions[1].players_count.should == 2
      @game.actions[1].previous_pot.should == 11.35
      @game.actions[1].total_pot.should == 37.15
      
      @game.actions[2].kind.should == 'turn'
      @game.actions[2].cards.should == ["6c"]
      #@game.actions[2].players_count.should == 2
      @game.actions[2].previous_pot.should == 37.15
      @game.actions[2].total_pot.should == 37.15
      
      @game.actions[3].kind.should == 'river'
      @game.actions[3].cards.should == ["3s"]
      #@game.actions[3].players_count.should == 2
      @game.actions[3].previous_pot.should == 37.15
      #@game.actions[3].events.should be_empty
      @game.actions[3].total_pot.should == 37.15
    end
    
    it "should parse game status" do
      @game.hero.stake.should == 17.65
      
      @game.players[2].should == @game.hero
      @game.players[2].stake.should == 17.65
      @game.players[2].winner.should be_false
      
      @game.players[0].winner.should be_true
      @game.players[0].stake.should == 17.65
      @game.players[0].sum.should == 35.30
    end
  end
  
  context "poker stars ru" do
    before(:all) do
      @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'pokerstars_ru.txt') )
      @parser = PokerHistory.parse(@source)
      @game = @parser.game
    end
    
    it "should parse game title" do
      @game.title.should == 'PS58147363149'
      @game.kind.should == 'HE'
      @game.limit_kind.should == 'HighLimits'
    end
    
    it "should parse game date" do
      @game.date.to_s.should == '2011-02-23T12:47:39+00:00'
    end
    
    it "should parse game table_name" do
      @game.table_name.should == 'Burgi XVI'
    end
    
    it "should parse game total_pot" do
      @game.total_pot.should == 15100
    end
    
    it "should parse game rake" do
      @game.rake.should == 0
    end
    
    it "should parse game max_players" do
      @game.max_players.should == 9
    end
    
    it "should parse game blinds_amounts" do
      @game.blinds_amounts.should == { :sb => 5, :bb => 10, :ante => 0.0 } 
    end
    
    it "should parse game description" do
      @game.description.should == "Холдем Безлимитный"
    end
    
    it "should parse game button_seat" do
      @game.button_seat.should == 1
    end
    
    it "should parse game board" do
      @game.board.should == ['3h', 'Qd', '6d', '9h', '4h']
    end
    
    it "should parse game stakes_type" do
      @game.stakes_type.should == 10
    end
    
    it "should parse game tournament" do
      @game.tournament.should be_nil
    end
    
    it "should parse game players" do
      @game.players_count.should == 5
      
      @game.players[0].seat.should == 1
      @game.players[0].name.should == 'cabizuela'
      @game.players[0].chips.should == 7100
      @game.players[0].kind.should == 'dealer'
      
      @game.players[1].seat.should == 4
      @game.players[1].name.should == 'Gazermann'
      @game.players[1].chips.should == 2915
      @game.players[1].kind.should == 'small_blind'
      @game.players[1].cards.should == ["Ac", "5c"]
      @game.players[1].hero.should be_true
            
      @game.players[2].seat.should == 5
      @game.players[2].name.should == 'Austria2201'
      @game.players[2].chips.should == 7795
      @game.players[2].kind.should == 'big_blind'
      
      @game.players[3].seat.should == 6
      @game.players[3].name.should == 'rauldobar'
      @game.players[3].chips.should == 880
      @game.players[3].kind.should == 'default'
      
      @game.players[4].seat.should == 7
      @game.players[4].name.should == 'madmax631'
      @game.players[4].chips.should == 7405
      @game.players[4].kind.should == 'default'
    end
    
    it "should parse game actions" do
      @game.actions.size.should == 5
      
      @game.actions[0].kind.should == 'preflop'
      @game.actions[0].cards.should be_nil
      @game.actions[0].previous_pot.should == 15
      @game.initial_pot_size.should == 15
      
      @game.actions[1].kind.should == 'flop'
      @game.actions[1].cards.should == ["3h", "Qd", "6d"]
      @game.actions[1].players_count.should == 5
      @game.actions[1].previous_pot.should == 50
      @game.actions[1].total_pot.should == 1580
      
      @game.actions[2].kind.should == 'turn'
      @game.actions[2].cards.should == ["9h"]
      @game.actions[2].players_count.should == 3
      @game.actions[2].previous_pot.should == 1580
      @game.actions[2].total_pot.should == 6080
      
      @game.actions[3].kind.should == 'river'
      @game.actions[3].cards.should == ["4h"]
      #@game.actions[3].players_count.should == 3
      @game.actions[3].previous_pot.should == 6080
      #@game.actions[3].events.should be_empty
      @game.actions[3].total_pot.should == 15100
    end
    
    it "should parse game status" do
      @game.hero.stake.should == 10
      
      @game.players[1].should == @game.hero
      @game.players[1].stake.should == 10
      @game.players[1].winner.should be_false
      
      @game.players[2].winner.should be_true
      @game.players[2].stake.should == 7100
      @game.players[2].sum.should == 12440
    end
  end
  
  context "poker stars ru" do
    before(:all) do
      @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'pokerstars2_ru.txt') )
      @parser = PokerHistory.parse(@source)
      @game = @parser.game
    end
    
    it "should parse game title" do
      @game.title.should == 'PS57282543704'
      @game.kind.should == 'HE'
      @game.limit_kind.should == 'HighLimits'
    end
    
    it "should parse game date" do
      @game.date.to_s.should == '2011-02-07T18:23:35+00:00'
    end
    
    it "should parse game table_name" do
      @game.table_name.should == 'Bistro L'
    end
    
    it "should parse game total_pot" do
      @game.total_pot.should == 1340
    end
    
    it "should parse game rake" do
      @game.rake.should == 0
    end
    
    it "should parse game max_players" do
      @game.max_players.should == 9
    end
    
    it "should parse game blinds_amounts" do
      @game.blinds_amounts.should == { :sb => 5, :bb => 10, :ante => 0.0 } 
    end
    
    it "should parse game description" do
      @game.description.should == "Холдем Безлимитный"
    end
    
    it "should parse game button_seat" do
      @game.button_seat.should == 2
    end
    
    it "should parse game board" do
      @game.board.should == ['7d', 'Th', '8d', '2h', '9c']
    end
    
    it "should parse game stakes_type" do
      @game.stakes_type.should == 10
    end
    
    it "should parse game tournament" do
      @game.tournament.should be_nil
    end
    
    it "should parse game players" do
      @game.players_count.should == 7
    end
  end
  
  context "full tilt poker" do
    context "game 1" do
      before(:all) do
        @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'fulltilt.txt') )
        @parser = PokerHistory.parse(@source)
        @game = @parser.game
      end
      
      it "should parse game title" do
        @game.title.should == 'FT28611675201'
        @game.kind.should == 'HE'
        @game.limit_kind.should == 'LowLimits'
      end
      
      it "should parse game date" do
        @game.date.to_s.should == '2011-02-28T20:24:11+00:00'
      end
      
      it "should parse game table_name" do
        @game.table_name.should == 'Citation'
      end
      
      it "should parse game total_pot" do
        @game.total_pot.should == 0.75
      end
      
      it "should parse game rake" do
        @game.rake.should == 0.03
      end
      
      it "should parse game max_players" do
        @game.max_players.should == 6
      end
      
      it "should parse game blinds_amounts" do
        @game.blinds_amounts.should == { :sb => 0.10, :bb => 0.25, :ante => 0.0 } 
      end
      
      it "should parse game description" do
        @game.description.should == "$0.10/$0.25 Hold'em No Limit"
      end
      
      it "should parse game button_seat" do
        @game.button_seat.should == 3
      end
      
      it "should parse game board" do
        @game.board.should == ['8c', '9s', 'Qd']
      end
      
      it "should parse game stakes_type" do
        @game.stakes_type.should == 0.25
      end
      
      it "should parse game limit" do
        @game.limit.should == 'NL'
      end
      
      it "should parse game kind" do
        @game.kind.should == 'HE'
      end
      
      it "should parse game players" do
        @game.players_count.should == 6
      end
      
      it "should parse game status" do
        @game.hero.stake.should == 0.25
        
        @game.players[4].should == @game.hero
        @game.players[4].stake.should == 0.25
        @game.players[4].winner.should be_false
        
        @game.players[5].winner.should be_true
        @game.players[5].stake.should == 1
        @game.players[5].sum.should == 0.72
      end
    end
    
    context "game 2" do
      before(:all) do
        @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'fulltilt2.txt') )
        @parser = PokerHistory.parse(@source)
        @game = @parser.game
      end
      
      it "should parse game title" do
        @game.title.should == 'FT28611751780'
        @game.kind.should == 'HE'
        @game.limit_kind.should == 'LowLimits'
      end
      
      it "should parse game date" do
        @game.date.to_s.should == '2011-02-28T20:26:40+00:00'
      end
      
      it "should parse game table_name" do
        @game.table_name.should == 'Citation'
      end
      
      it "should parse game total_pot" do
        @game.total_pot.should == 5
      end
      
      it "should parse game rake" do
        @game.rake.should == 0.25
      end
      
      it "should parse game max_players" do
        @game.max_players.should == 6
      end
      
      it "should parse game blinds_amounts" do
        @game.blinds_amounts.should == { :sb => 0.10, :bb => 0.25, :ante => 0.0 } 
      end
      
      it "should parse game description" do
        @game.description.should == "$0.10/$0.25 Hold'em No Limit"
      end
      
      it "should parse game button_seat" do
        @game.button_seat.should == 1
      end
      
      it "should parse game board" do
        @game.board.should == ['6h', 'Ad', '7d', '8h', '9h']
      end
      
      it "should parse game stakes_type" do
        @game.stakes_type.should == 0.25
      end
      
      it "should parse game limit" do
        @game.limit.should == 'NL'
      end
      
      it "should parse game kind" do
        @game.kind.should == 'HE'
      end
      
      it "should parse game players" do
        @game.players_count.should == 6
      end
      
      it "should parse game status" do
        @game.hero.stake.should == 0
        
        @game.players[4].should == @game.hero
        @game.players[4].stake.should == 0
        @game.players[4].winner.should be_false
        
        @game.players[2].winner.should be_true
        @game.players[2].stake.should == 2.25
        @game.players[2].sum.should == 4.75
      end
    end
  end
  
  context "party poker 2" do
    before(:all) do
      @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'partypoker2.txt') )
      @parser = PokerHistory.parse(@source)
      @game = @parser.game
    end
    
    it "should parse game title" do
      @game.title.should == 'PP59977110408'
      @game.kind.should == 'OH'
      @game.limit_kind.should == 'AverageLimits'
    end
    
    it "should parse game date" do
      @game.date.to_s.should == '2011-03-28T12:28:46+00:00'
    end
    
    it "should parse game table_name" do
      @game.table_name.should == 'Cressida IX (Real Money)'
    end
    
    it "should parse game total_pot" do
      @game.total_pot.should == 2636.9
    end
    
    it "should parse game rake" do
      @game.rake.should == 0
    end
    
    it "should parse game max_players" do
      @game.max_players.should == 0
    end
    
    it "should parse game blinds_amounts" do
      @game.blinds_amounts.should == { :sb => 3.0, :bb => 6.0, :ante => 0.0 } 
    end
    
    it "should parse game description" do
      @game.description.should == "Omaha"
    end
    
    it "should parse game button_seat" do
      @game.button_seat.should == 5
    end
    
    it "should parse game board" do
      @game.board.should == ['7c', 'Kh', '2c', 'Jc', '2d']
    end
    
    it "should parse game stakes_type" do
      @game.stakes_type.should == 600.0
    end
    
    it "should parse game tournament" do
      @game.tournament.should be_nil
    end
    
    it "should parse game players" do
      @game.players_count.should == 6
    end
    
    it "should parse game status" do
      @game.hero.stake.should == 1317.0
      
      @game.players[5].should == @game.hero      
      @game.players[5].winner.should be_true
      @game.players[5].stake.should == 1317.0
      @game.players[5].sum.should == 2630.80
    end
  end

  context "holdem manager" do
    before(:all) do
      @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'holdem_manager.txt') )
      @parser = PokerHistory.parse(@source)
      @game = @parser.game
    end
    
    it "should parse game title" do
      @game.title.should == 'PP59321376937'
      @game.kind.should == 'HE'
      @game.limit_kind.should == 'HighLimits'
    end
    
    it "should parse game date" do
      @game.date.to_s.should == '2011-03-17T06:36:47+00:00'
    end
    
    it "should parse game table_name" do
      @game.table_name.should == 'Elpis VIII (Real Money)'
    end
    
    it "should parse game total_pot" do
      @game.total_pot.should == 1745.0
    end
    
    it "should parse game rake" do
      @game.rake.should == 0
    end
    
    it "should parse game max_players" do
      @game.max_players.should == 0
    end
    
    it "should parse game blinds_amounts" do
      @game.blinds_amounts.should == { :sb => 5, :bb => 10, :ante => 0.0 } 
    end
    
    it "should parse game description" do
      @game.description.should == "Texas Hold'em"
    end
    
    it "should parse game button_seat" do
      @game.button_seat.should == 2
    end
    
    it "should parse game board" do
      @game.board.should == ["Th", "8s", "Qs", "2s", "5h"]
    end
    
    it "should parse game stakes_type" do
      @game.stakes_type.should == 1000.0
    end
    
    it "should parse game tournament" do
      @game.tournament.should be_nil
    end
    
    it "should parse game players" do
      @game.players_count.should == 2
    end
  end
  
  context "holdem manager 2" do
    before(:all) do
      @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'holdem_manager2.txt') )
      @parser = PokerHistory.parse(@source)
      @game = @parser.game
    end
    
    it "should parse game title" do
      @game.title.should == 'PP30647502872'
      @game.kind.should == 'HE'
      @game.limit_kind.should == 'UltrahighLimits'
    end
    
    it "should parse game date" do
      @game.date.to_s.should == '2011-05-23T05:31:35+00:00'
    end
    
    it "should parse game table_name" do
      @game.table_name.should == 'MiniFTOPS Main Event (234094317) Table 1302 (Real Money)'
    end
    
    it "should parse game total_pot" do
      @game.total_pot.should == 217991.0
    end
    
    it "should parse game rake" do
      @game.rake.should == 0
    end
    
    it "should parse game max_players" do
      @game.max_players.should == 0
    end
    
    it "should parse game blinds_amounts" do
      @game.blinds_amounts.should == { :sb => 1200.0, :bb => 2400.0, :ante => 300.0 } 
    end
    
    it "should parse game description" do
      @game.description.should == "Tourney Hand NL Texas Hold'em"
    end
    
    it "should parse game button_seat" do
      @game.button_seat.should == 1
    end
    
    it "should parse game board" do
      @game.board.should == ["9s", "Jc", "5d", "2d", "Jh"]
    end
    
    it "should parse game stakes_type" do
      @game.stakes_type.should be_nil
    end
    
    it "should parse game tournament" do
      @game.tournament.should be_nil
    end
    
    it "should parse game players" do
      @game.players_count.should == 9
    end
    
    it "should parse game status" do
      @game.hero.stake.should == 70448.0
      
      @game.players[7].should == @game.hero      
      @game.players[7].winner.should be_true
      @game.players[7].stake.should == 70448.0
      @game.players[7].sum.should == 146596.00
    end
  end
  
  context "holdem manager 3" do
    before(:all) do
      @source = File.read( Rails.root.join('spec', 'factories', 'paperclip', 'holdem_manager3.txt') )
      @parser = PokerHistory.parse(@source)
      @game = @parser.game
    end
    
    it "should parse game title" do
      @game.title.should == 'PP30646542604'
      @game.kind.should == 'HE'
      @game.limit_kind.should == 'UltrahighLimits'
    end
    
    it "should parse game date" do
      @game.date.to_s.should == '2011-05-23T16:36:39+00:00'
    end
    
    it "should parse game table_name" do
      @game.table_name.should == 'MiniFTOPS Main Event (234094317) Table 629 (Real Money)'
    end
    
    it "should parse game total_pot" do
      @game.total_pot.should == 69084.0
    end
    
    it "should parse game rake" do
      @game.rake.should == 0
    end
    
    it "should parse game max_players" do
      @game.max_players.should == 0
    end
    
    it "should parse game blinds_amounts" do
      @game.blinds_amounts.should == { :sb => 600.0, :bb => 1200.0, :ante => 150.0 } 
    end
    
    it "should parse game description" do
      @game.description.should == "Tourney Hand NL Texas Hold'em"
    end
    
    it "should parse game button_seat" do
      @game.button_seat.should == 5
    end
    
    it "should parse game board" do
      @game.board.should == ["4h", "Kh", "Jd", "7s", "2d"]
    end
    
    it "should parse game stakes_type" do
      @game.stakes_type.should be_nil
    end
    
    it "should parse game tournament" do
      @game.tournament.should be_nil
    end
    
    it "should parse game players" do
      @game.players_count.should == 9
    end
  end
end

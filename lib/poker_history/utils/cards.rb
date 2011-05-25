module PokerHistory
  module Utils
    class Cards
      RANKS = %w{ A K Q J T 9 8 7 6 5 4 3 2 }
      SUITS = %w{ s d c h }
    
      VALID_LIST = RANKS.collect {|r| SUITS.collect {|s| r + s } }.flatten
      
      def self.parse(value)
        unless value.blank?
          value.to_s.gsub(/\s+/, ',').gsub(/\,{2,}/, ',').split(',').delete_if { |item| item.blank? }
        end
      end
    end
  end
end

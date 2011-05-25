# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{poker_history}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Igor Galeta"]
  s.date = %q{2011-05-25}
  s.description = %q{Poker hands history parser. Supported rooms: PokerStars, PartyPoker, FullTilt}
  s.email = %q{galeta.igor@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "lib/poker_history.rb",
    "lib/poker_history/action.rb",
    "lib/poker_history/event.rb",
    "lib/poker_history/game.rb",
    "lib/poker_history/player.rb",
    "lib/poker_history/rooms/base.rb",
    "lib/poker_history/rooms/full_tilt.rb",
    "lib/poker_history/rooms/party_poker.rb",
    "lib/poker_history/rooms/poker_stars.rb",
    "lib/poker_history/utils/cards.rb",
    "lib/poker_history/utils/rules.rb",
    "lib/poker_history/utils/time_string_converter.rb",
    "spec/factories/assets/fulltilt.txt",
    "spec/factories/assets/fulltilt2.txt",
    "spec/factories/assets/holdem_manager.txt",
    "spec/factories/assets/holdem_manager2.txt",
    "spec/factories/assets/holdem_manager3.txt",
    "spec/factories/assets/partypoker.txt",
    "spec/factories/assets/partypoker2.txt",
    "spec/factories/assets/pokerstars.txt",
    "spec/factories/assets/pokerstars2.txt",
    "spec/factories/assets/pokerstars2_ru.txt",
    "spec/factories/assets/pokerstars_ru.txt",
    "spec/models/poker_history_spec.rb"
  ]
  s.homepage = %q{https://github.com/galetahub/poker_history}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Poker hands history parser}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end


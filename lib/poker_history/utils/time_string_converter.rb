require 'tzinfo'

module PokerHistory
  module Utils
    class TimeStringConverter
      attr_accessor :timestring
      
      def initialize(timestring)
        @timestring = timestring
        
        if @timestring =~ /^(.*)\s+\[(.+)\]/
          @timestring = $1
        end
        
        parse_timestring
        self
      end

      def as_utc_datetime
        time_converter.local_to_utc(DateTime.parse(@timestring))
      end

      private
      
      def parse_timestring
        if @timestring =~ /^(.*)\s+\(?(UTC|PT|MT|CT|ET|AT|BRT|WET|CET|EET|MSK|CCT|JST|AWST|ACST|AEST|NZT)\)?/
          @localtime = $1
          @ps_timezone_string = $2
        else
          raise Rooms::ParseError, "#{@timestring}: does not end with a valid Pokerstars time zone suffix"
        end
      end
      
      def time_converter
        case @ps_timezone_string
          when "ACST" then TZInfo::Timezone.get('Australia/Adelaide')
          when "AEST" then TZInfo::Timezone.get('Australia/Melbourne')
          when "AT"   then TZInfo::Timezone.get('Canada/Atlantic')
          when "AWST" then TZInfo::Timezone.get('Australia/West')
          when "BRT"  then TZInfo::Timezone.get('Brazil/East')
          when "CCT"  then TZInfo::Timezone.get('Indian/Cocos')
          when "CET"  then TZInfo::Timezone.get('Europe/Amsterdam')
          when "CT"   then TZInfo::Timezone.get('US/Central')
          when "ET"   then TZInfo::Timezone.get('US/Eastern')
          when "EET"  then TZInfo::Timezone.get('EET')
          when "JST"  then TZInfo::Timezone.get('Japan')
          when "MSK"  then TZInfo::Timezone.get('Europe/Moscow')
          when "MT"   then TZInfo::Timezone.get('US/Mountain')
          when "NZT"  then TZInfo::Timezone.get('NZ')
          when "PT"   then TZInfo::Timezone.get('US/Pacific')
          when "UTC"  then TZInfo::Timezone.get('UTC')
          when "WET"  then TZInfo::Timezone.get('WET')
        end
      end
    end
  end
end

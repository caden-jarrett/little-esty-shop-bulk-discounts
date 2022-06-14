class HolidayFacade
  def self.summon_holidays
    json = HolidayService.summon_holiday_info
    json.first(3).map do |info|
      Holiday.new(info)
    end
  end
end

module Concerns::Scheduling
  extend ActiveSupport::Concern

  included do |variable|
Rails.logger.debug("concern included ===============================================================================")
    
    attr_accessor :schedule_info

    after_initialize :create_schedule_info
    after_find :load_schedule_info
    before_validation :save_schedule_info

    def self.form_attributes
      # Content's original form_attributes, plus our new ones
      [:name, :duration, :data, {:start_time => [:time, :date]}, {:end_time => [:time, :date]}] + [:schedule_info => [:criteria, :start_time, :end_time]]
    end
  end

  module ClassMethods
  end

  def is_active_per_schedule?
    active = true

    if self.blank? or self.schedule_info.blank? or !self.schedule_info.is_a?(Hash) or
      !self.schedule_info.include?("start_time") or !self.schedule_info.include?("end_time") or
      !self.schedule_info.include?("criteria") or self.schedule_info["start_time"].blank? or
      self.schedule_info["end_time"].blank? or self.schedule_info["criteria"].blank?
      # missing or incomplete schedule information so assume active
    else
      # see if it is within the viewing window for the day
      begin
        if Clock.time >= Time.parse(self.schedule_info['start_time']) && Clock.time <= Time.parse(self.schedule_info['end_time'])
          # and it matches the criteria
          s = IceCube::Schedule.new(self.start_time)
          s.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(self.schedule_info['criteria']))
          active = s.occurs_on? Clock.time
        else
          active = false
        end
      rescue => e
        active = false
        Rails.logger.error("Unable to determine if schedule is active - #{e.message} for content #{self.id}")
      end
    end

    active
  end

  def create_schedule_info
    self.schedule_info = { 
      "start_time" => ConcertoConfig[:content_default_start_time], 
      "end_time" => ConcertoConfig[:content_default_end_time], 
      "criteria" => nil 
    } if self.schedule_info.nil?
  end

  def load_schedule_info
    self.schedule_info = JSON.load(self.schedule) rescue {}
  end

  def save_schedule_info
    self.schedule = JSON.dump(self.schedule_info)
  end

end

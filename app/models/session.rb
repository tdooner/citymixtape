class Session < ApplicationRecord
  self.primary_key = :session_id

  serialize :stars, JSON

  def self.star!(session_id, object_type, object_id)
    transaction do
      find_or_create_by(session_id: session_id).tap do |record|
        record.stars ||= []
        record.stars |= [[object_type, object_id.to_i]]
        record.save
      end
    end
  end

  def self.unstar!(session_id, object_type, object_id)
    transaction do
      find_by(session_id: session_id).tap do |record|
        return unless record
        record.stars ||= []
        record.stars -= [[object_type, object_id.to_i]]
        record.save
      end
    end
  end
end

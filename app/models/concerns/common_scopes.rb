module CommonScopes
  extend ActiveSupport::Concern

  def self.included(base)
    base.instance_eval do
      scope :filter_by_name, ->(name) do
        where('lower(name) like ?', "%#{name.strip.downcase}%")
      end
    end
  end
end
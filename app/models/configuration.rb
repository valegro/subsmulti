class Configuration < ActiveRecord::Base
  serialize :value
  has_attached_file :provider_logo
  validates :key, presence: true, uniqueness: true
  validates :form_type, presence: true
  validates_attachment_content_type :provider_logo, content_type: %r{\Aimage/}

  class_attribute :settings
  self.settings = []

  cattr_accessor :provider_logo_file_name, :provider_logo_content_type

  SUPPORTED_CURRENCIES = %w( AUD BTC CAD EUR USD )

  CURRENCY_OPTIONS = Money::Currency.table
    .select { |_, c| SUPPORTED_CURRENCIES.include? c[:iso_code] }
    .sort { |a, b| a[1][:iso_code] <=> b[1][:iso_code] }
    .map { |c| [ "#{c[1][:name]} (#{c[1][:iso_code]})", c[1][:iso_code] ] }

  def self.ensure_created
    settings.each { |setting| send(setting) }
  end

  def self.setting(name, default, form_type, form_collection_command = '')
    class_eval <<-EOC
      self.settings << "#{name}"
      def self.#{name}
        @#{name} ||= (
          self.find_or_create_by(key: "#{name}") do |config|
            config.value = #{default}
            config.form_type = "#{form_type}"
            config.form_collection_command = "#{form_collection_command}"
          end
        ).value
      end
      def self.#{name}=(value)
        config = self.find_or_create_by(key: "#{name}")
        config.value = value
        config.save!
        @#{name} = value
      end
    EOC
  end

  # Accessors for provider_logo class attribute
  def self.provider_logo
    config = find_or_create_by(key: 'provider_logo', form_type: 'file')
    @@provider_logo_file_name = config.value.presence # rubocop:disable Style/ClassVars
    @@provider_logo_content_type = nil # rubocop:disable Style/ClassVars
    config.provider_logo
  end

  def self.provider_logo=(attachment)
    config = find_by(key: 'provider_logo')
    config.provider_logo = attachment
    config.value = @@provider_logo_file_name
    config.save!
  end

  # Define settings by listing them here
  setting :provider_name, "'Organisation Name'", :string
  settings << 'provider_logo'

  # Ensure all the defaults are created when the class file is read
  ensure_created if connection.table_exists? configurations
end

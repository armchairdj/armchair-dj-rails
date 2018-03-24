require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id:                     Field::Number,
    email:                  Field::String,
    encrypted_password:     Field::String,
    reset_password_token:   Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at:    Field::DateTime,
    sign_in_count:          Field::Number,
    current_sign_in_at:     Field::DateTime,
    last_sign_in_at:        Field::DateTime,
    current_sign_in_ip:     Field::String.with_options(searchable: false),
    last_sign_in_ip:        Field::String.with_options(searchable: false),
    confirmation_token:     Field::String,
    confirmed_at:           Field::DateTime,
    confirmation_sent_at:   Field::DateTime,
    unconfirmed_email:      Field::String,
    failed_attempts:        Field::Number,
    unlock_token:           Field::String,
    locked_at:              Field::DateTime,
    created_at:             Field::DateTime,
    updated_at:             Field::DateTime,
    role:                   Field::String.with_options(searchable: false),
    first_name:             Field::String,
    middle_name:            Field::String,
    last_name:              Field::String,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :email,
    :first_name,
    :last_name,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :role,
    :first_name,
    :middle_name,
    :last_name,
    :email,

    :created_at,
    :updated_at,

    :encrypted_password,
    :reset_password_token,
    :reset_password_sent_at,

    :unconfirmed_email,
    :confirmation_token,
    :confirmed_at,
    :confirmation_sent_at,

    :sign_in_count,
    :current_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_at,
    :last_sign_in_ip,
    :remember_created_at,

    :locked_at,
    :unlock_token,
    :failed_attempts,
  ].freeze

  FORM_ATTRIBUTES = [
    :email,
    :first_name,
    :middle_name,
    :last_name,
    :role,
  ].freeze

  def display_resource(user)
    return "New User" unless (displayable = user.display_name).present?

    displayable
  end
end

module AdminEngine
  class Admin < ApplicationRecord
    self.table_name = :admin_engine_admins

    ROLES = %w(developer operator editor admin_manager user_manager).freeze
    STATUS = %w(pending active blocked archived).freeze

    after_initialize :define_has_role_methods

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "not valid" }
    validates :name, length: { in: 3..255 }
    # this uses our custom ArrayInclusionValidator
    validates :roles, array_inclusion: { in: ROLES, message: "%{rejected_values} not allowed, roles must be in #{ROLES}" }
    validates :status, inclusion: { in: STATUS }

    def add_role(role)
      unless ROLES.include?(role.to_s)
        errors.add(:roles, "invalid role, must be in #{ROLES}")
        return self
      end

      roles << role.to_s
      roles.uniq!

      self
    end

    def add_role!(role)
      add_role(role).save!
    end

    def remove_role(role)
      self.roles -= Array(role.to_s)
      self
    end

    def remove_role!(role)
      remove_role(role).save!
    end

    private

    # defines role? query methods
    def define_has_role_methods
      ROLES.each do |role|
        self.class.send(:define_method, "#{role}?".to_sym) do
          roles.include?(role.to_s)
        end
      end
    end
  end
end

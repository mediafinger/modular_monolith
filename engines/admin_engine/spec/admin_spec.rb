require "rails_helper"

RSpec.shared_examples "has_role?" do |role|
  it "#{role}? returns true when role #{role} is set" do
    admin.add_role(role.to_sym)

    expect(admin.public_send("#{role}?".to_sym)).to be true
  end

  it "#{role}? returns false when role #{role} is not set" do
    expect(admin.public_send("#{role}?")).to be false
  end
end

RSpec.describe AdminEngine::Admin, type: :model do
  let(:email) { "andy+5@bs.dev-and-ops.museum" }
  let(:name)  { "Andreas Finger" }

  describe "validation" do
    context "valid" do
      it "creates an admin", :aggregated_failures do
        admin = described_class.create!(name: name, email: email)

        expect(admin).to be_valid
      end
    end

    context "invalid name" do
      it "fails" do
        admin = described_class.new(name: "x", email: email)

        expect(admin).not_to be_valid
      end
    end

    context "invalid email" do
      it "fails" do
        admin = described_class.new(name: name, email: "missing-the.at.com")

        expect(admin).not_to be_valid
      end
    end
  end

  context "roles" do
    subject(:admin)    { described_class.create!(name: name, email: email) }

    let(:valid_role)   { described_class::ROLES.first }
    let(:invalid_role) { "Bundeskanzler" }

    described_class::ROLES.each { |role| include_examples("has_role?", role) }

    describe "#add_role" do
      it "returns self" do
        expect(admin.add_role(invalid_role)).to eq(admin)
      end

      it "does not update the record in the database" do
        admin.add_role(valid_role)
        admin.reload

        expect(admin.roles).to be_empty
      end

      context "valid" do
        it "is idempotent, adds the role only once", :aggregated_failures do
          expect(admin.add_role(valid_role)).to be_truthy

          admin.add_role(valid_role)
          expect(admin.roles).to eq(Array(valid_role))
        end
      end

      context "invalid" do
        it "ensures only whitelisted roles are saved" do
          expect { admin.add_role(invalid_role) }.not_to raise_error
          expect(admin.errors).not_to be_empty
          expect(admin.reload.roles).to be_empty
        end
      end
    end

    describe "#add_role!" do
      context "valid" do
        it "is idempotent, adds the role only once", :aggregated_failures do
          expect(admin.add_role!(valid_role)).to be_truthy

          admin.add_role!(valid_role)

          expect(admin.roles).to eq(Array(valid_role))
        end
      end

      context "invalid" do
        it "ensures only whitelisted roles are saved, ignores invalid roles" do
          expect { admin.add_role!(invalid_role) }.not_to raise_error
          expect(admin.reload.roles).to be_empty
        end
      end
    end

    describe "#remove_role" do
      subject(:admin) { described_class.create!(name: name, email: email, roles: [valid_role]) }

      it "returns self" do
        expect(admin.remove_role(valid_role)).to eq(admin)
      end

      it "does not update the record in the database" do
        admin.remove_role(valid_role)
        admin.reload

        expect(admin.roles).to eq([valid_role])
      end

      it "removes an existing role" do
        admin.remove_role(valid_role)

        expect(admin.roles).to eq([])
      end

      it "is idempotent, does not raise when the admin does not have the role" do
        admin.remove_role(valid_role)
        admin.remove_role(valid_role)

        expect(admin.roles).to eq([])
      end
    end

    describe "#remove_role!" do
      subject(:admin) { described_class.create!(name: name, email: email, roles: [valid_role]) }

      it "removes an existing role" do
        admin.remove_role!(valid_role)

        expect(admin.roles).to eq([])
      end

      it "is idempotent, does not raise when the admin does not have the role" do
        admin.remove_role!(valid_role)
        admin.remove_role!(valid_role)

        expect(admin.roles).to eq([])
      end
    end

    # direct usage is discouraged, has to work properly nevertheless
    describe "#roles=" do
      context "valid" do
        it "works", :aggregated_failures do
          admin.roles = Array(valid_role)

          expect(admin.save!).to be_truthy
        end
      end

      context "invalid" do
        it "ensures only whitelisted roles are saved" do
          admin.roles = Array(invalid_role)

          expect { admin.save! }.to raise_error(ActiveRecord::RecordInvalid)
          expect(admin.reload.roles).to be_empty
        end
      end
    end
  end
end

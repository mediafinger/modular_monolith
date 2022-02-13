# frozen_string_literal: true

require "rails_helper"

RSpec.describe Settings do
  it "register without default value" do
    cached_env_var = ENV["ENV_VAR"]
    ENV["ENV_VAR"] = "settings_test"

    described_class.register :env_var

    expect(described_class.env_var).to eq("settings_test")

    ENV["ENV_VAR"] = cached_env_var
  end

  it "register with default value" do
    described_class.register :some_test_default, default: "default value"

    expect(described_class.some_test_default).to eq("default value")
  end

  it "register when a prefix is given" do
    cached_env_var = ENV["ENV_VAR"]
    cached_prefixed_env_var = ENV["ENV_VAR"]
    ENV["ENV_VAR"] = "without"
    ENV["PREFIXED_ENV_VAR"] = "with prefix"

    described_class.register :env_var, prefix: "PREFIXED"

    expect(described_class.env_var).to eq("with prefix")

    ENV["ENV_VAR"] = cached_env_var
    ENV["PREFIXED_ENV_VAR"] = cached_prefixed_env_var
  end

  context "when a ENV is mandatory" do
    it "register when set" do
      cached_env_var = ENV["ENV_VAR"]
      ENV["ENV_VAR"] = "it works"

      described_class.register :env_var, mandatory: true

      expect(described_class.env_var).to eq("it works")

      ENV["ENV_VAR"] = cached_env_var
    end

    it "register in development environment" do
      cached_rails_env = ENV["RAILS_ENV"]
      ENV["RAILS_ENV"] = "development"

      described_class.register :env_var, mandatory: true, default: "dev_value"

      expect(described_class.env_var).to eq("dev_value")

      ENV["RAILS_ENV"] = cached_rails_env
    end

    it "fails when not set" do
      cached_rails_env = ENV["RAILS_ENV"]
      ENV["RAILS_ENV"] = "production"

      expect { described_class.register :env_var, mandatory: true }
        .to raise_error(KeyError, "key not found: \"ENV_VAR\"")

      ENV["RAILS_ENV"] = cached_rails_env
    end

    it "fails also when default is given" do
      cached_rails_env = ENV["RAILS_ENV"]
      ENV["RAILS_ENV"] = "production"

      expect { described_class.register :env_var, mandatory: true, default: :doesnt_matter }
        .to raise_error(KeyError, "key not found: \"ENV_VAR\"")

      ENV["RAILS_ENV"] = cached_rails_env
    end
  end

  context "different data types" do
    before do
      described_class.register :some_test_bootup_time, default: Time.current
      described_class.register :some_test_false,       default: false
      described_class.register :some_test_true,        default: true
      described_class.register :some_test_number,      default: 5
      described_class.register :some_test_string,      default: "http://example.com"
    end

    it "tests some current setup values", :aggregate_failures do
      expect(described_class.some_test_bootup_time).to be_within(3.minutes).of(Time.current)
      expect(described_class.some_test_false).to       eq(false)
      expect(described_class.some_test_true).to        eq(true)
      expect(described_class.some_test_number).to      eq(5)
      expect(described_class.some_test_string).to      eq("http://example.com")
    end

    it "keeps the correct data types", :aggregate_failures do
      expect(described_class.some_test_bootup_time).to be_a(Time)
      expect(described_class.some_test_false).to       be_a(FalseClass)
      expect(described_class.some_test_true).to        be_a(TrueClass)
      expect(described_class.some_test_number).to      be_a(Integer)
      expect(described_class.some_test_string).to      be_a(String)
    end

    it ".is? compares the values as Strings", :aggregate_failures do
      expect(described_class.is?(:some_test_false, false)).to   eq true
      expect(described_class.is?(:some_test_false, "false")).to eq true
      expect(described_class.is?(:some_test_true, true)).to     eq true
      expect(described_class.is?(:some_test_true, "true")).to   eq true
      expect(described_class.is?(:some_test_number, 5)).to      eq true
      expect(described_class.is?(:some_test_number, "5")).to    eq true
    end
  end
end

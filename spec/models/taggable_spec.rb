# frozen_string_literal: true

require "rails_helper"

RSpec.describe Taggable do
  fixtures :all

  it "tag and untag by name" do
    register = registers(:first_bank)
    expect(register.taggings.joins(:tag).exists?(subject: register, tags: {name: "foo"})).to be_falsy

    register.tag("foo")
    expect(register.taggings.joins(:tag).exists?(subject: register, tags: {name: "foo"})).to be_truthy

    register.untag("foo")
    expect(register.taggings.joins(:tag).exists?(subject: register, tags: {name: "foo"})).to be_falsy
  end

  it "tag a second time with the same name" do
    register = registers(:first_bank)
    expect(register.tags.size).to eq 0 # force early load of the association
    register.tag("foo")
    expect(register.tags.size).to eq 1 # re-used association (to make sure it is reloaded when it changed)
    expect(register.taggings.joins(:tag).exists?(subject: register, tags: {name: "foo"})).to be_truthy
    register.tag("foo")
    expect(register.taggings.joins(:tag).where(subject: register, tags: {name: "foo"}).count).to eq 1
  end

  it "untag a tag not already tagged silently does nothing" do
    register = registers(:first_bank)
    expect(register.tags.map(&:name)).not_to include("bar")
    register.untag("bar")
    expect(register.tags.map(&:name)).not_to include("bar")
  end
end

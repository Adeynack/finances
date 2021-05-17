# frozen_string_literal: true

require "test_helper"

class TaggableTest < ActiveSupport::TestCase
  test "tag and untag by name" do
    register = registers(:first_bank)
    assert_not register.taggings.joins(:tag).exists?(subject: register, tags: { name: "foo" })

    register.tag("foo")
    assert register.taggings.joins(:tag).exists?(subject: register, tags: { name: "foo" })

    register.untag("foo")
    assert_not register.taggings.joins(:tag).exists?(subject: register, tags: { name: "foo" })
  end

  test "tag a second time with the same name" do
    register = registers(:first_bank)
    assert_equal 0, register.tags.size # force early load of the association
    register.tag("foo")
    assert_equal 1, register.tags.size # re-used association (to make sure it is reloaded when it changed)
    assert register.taggings.joins(:tag).exists?(subject: register, tags: { name: "foo" })
    register.tag("foo")
    assert_equal 1, register.taggings.joins(:tag).where(subject: register, tags: { name: "foo" }).count
  end

  test "untag a tag not already tagged" do
    register = registers(:first_bank)
    register.tag("foo")
    register.untag("bar")
    # just make sure it does not fail
  end
end

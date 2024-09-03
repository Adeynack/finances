# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationCable do
  describe ApplicationCable::Channel do
    it "is referenced for code coverage" do
      expect(ApplicationCable::Channel).to be_a Class
    end
  end

  describe ApplicationCable::Connection do
    it "is referenced for code coverage" do
      expect(ApplicationCable::Channel).to be_a Class
    end
  end
end

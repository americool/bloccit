require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) {Question.create!(title: "New Question", body: "New Body")}
  describe "attributes" do
    it "should respond to title" do
      expect(question).to respond_to(:title)
    end
    it "should respond to body" do
      expect(question).to respond_to(:title)
    end
  end
end

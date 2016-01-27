require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) {Question.create!(title:"This is my question?", body: "This is the body.")}
  let(:answer) {Answer.create!(body: 'Answer Body', question: question)}

  describe "answer attributes" do
    it "should respond to body" do
      expect(answer).to respond_to(:body)
    end
  end
end

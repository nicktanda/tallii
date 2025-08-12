require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  # The ApplicationHelper is currently empty, but we test it to ensure
  # the helper framework is working correctly
  describe 'ApplicationHelper' do
    it 'is included in the helper' do
      expect(helper.class.ancestors).to include(ApplicationHelper)
    end

    it 'responds to helper methods inherited from ActionView' do
      expect(helper).to respond_to(:content_for)
      expect(helper).to respond_to(:link_to)
      expect(helper).to respond_to(:form_with)
    end
  end
end
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:user_one)
  end


  test 'valid user' do
  	assert @user.valid?
  end

  test 'has friendly name' do
  	assert_equal 'John Smith', @user.friendly_name
  end

end

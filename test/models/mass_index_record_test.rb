require 'test_helper'

class MassIndexRecordTest < ActiveSupport::TestCase

  test "Should not save if without a present numeric mass index (default 0.0)" do
    user = User.create email: 'omarandstuff@gmail.com', password: '12345678'
    record = MassIndexRecord.new user: user
    assert record.save

    record = MassIndexRecord.new body_mass_index: "dada", user: user
    assert_not record.save
    assert record.errors.messages[:body_mass_index]
  end

  test "Should not save if it's not asociated with a user" do
    record = MassIndexRecord.new body_mass_index: 666
    assert_not record.save
    assert record.errors.messages[:user]
  end

  test "Should save with the right body mass index and user" do
    user = User.create email: 'omarandstuff@gmail.com', password: '12345678'
    record = MassIndexRecord.new body_mass_index: 666, user: user
    assert record.save
  end

  test "Should respond to user association" do
    user = User.create email: 'omarandstuff@gmail.com', password: '12345678'
    record = MassIndexRecord.create body_mass_index: 666, user: user

    assert record.user
  end
end

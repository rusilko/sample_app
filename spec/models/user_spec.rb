require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject a name which is too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    valid_addresses = %w[tomek@gmail.com foo.bar@b.pl f_f@fo.bar.org]
    valid_addresses.each do |adr|
      user = User.new(@attr.merge(:email => adr))
      user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    invalid_addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    invalid_addresses.each do |adr|
      user = User.new(@attr.merge(:email => adr))
      user.should_not be_valid
    end
  end
  
  it "should rejecy duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicated_email = User.new(@attr)
    user_with_duplicated_email.should_not be_valid
  end
  
  it "should reject duplicate email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicated_email = User.new(@attr)
    user_with_duplicated_email.should_not be_valid
  end  
end


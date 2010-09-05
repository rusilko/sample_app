require 'spec_helper'

describe User do

  before(:each) do
    @attr = { 
      :name  => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
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
  
  describe "password validations" do
  
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
      end
  
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "not_foobar")).
        should_not be_valid
    end
  
    it "should reject short passwords" do
      short = "a" * 5
      User.new(@attr.merge(:password => short, :password_confirmation => short)).
        should_not be_valid
    end
  
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid      
    end
  end
  
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should save the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
    
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
    
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid password").should be_false
      end
    end
  
    describe "User.authenticate method" do
      it "should return nil when email/pass combination is invalid" do
        wrong_password_user = User.authenticate(@attr[:email], "invalid password")
        wrong_password_user.should be_nil
      end
      
      it "should retudn nil when no user exist with a given e-mail address" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      
      it "should return a User object when user exists and email/pass combinaion is valid" do
        correct_user = User.authenticate(@attr[:email], @attr[:password])
        correct_user.should == @user
      end
    end        
  end        
end

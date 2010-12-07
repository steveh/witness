require "spec_helper"

include Verify

class BaseTestHelper < Base

  action :generate, :receive

  column :first_name
  column :last_name, :type => :string, :name => "Person last name"
  column :age, :type => :integer
  column :base_type, :type => :symbol
  column :data, :type => nil

  validates_presence_of :first_name, :age
  validates_presence_of :last_name, :on => :generate
  validates_presence_of :base_type, :on => :receive

end

describe Base do

  it "should not allow initialization" do
    BaseTestHelper.new.should raise_error
  end

  describe "action definition" do

    it "should respond to a defined call" do
      BaseTestHelper.generate({ :first_name => "First", :last_name => "Last", :age => "42" })
    end

    it "should not respond to an undefined defined call" do
      lambda { BaseTestHelper.banana({}) }.should raise_error(NoMethodError)
    end

  end

  describe "column definition" do

    it "should define a default name" do
      BaseTestHelper.columns[:first_name][:name].should == "First name"
    end

    it "should allow override names" do
      BaseTestHelper.columns[:last_name][:name].should == "Person last name"
    end

    it "should define a default type" do
      BaseTestHelper.columns[:first_name][:type].should == :string
    end

    it "should allow string types" do
      BaseTestHelper.columns[:last_name][:type].should == :string
    end

    it "should allow integer types" do
      BaseTestHelper.columns[:age][:type].should == :integer
    end

    it "should allow symbol types" do
      BaseTestHelper.columns[:base_type][:type].should == :symbol
    end

  end

  describe "validates presence of" do

    it "should raise an error for a nil param" do
      lambda { BaseTestHelper.generate({ :first_name => nil }) }.should raise_error(Error, /name not set/)
    end

    it "should raise an error for an empty param" do
      lambda { BaseTestHelper.generate({ :first_name => "" }) }.should raise_error(Error, /name not set/)
    end

    it "should not raise an error for a set param" do
      lambda { BaseTestHelper.generate({ :first_name => "First", :last_name => "Last", :age => "42" }) }.should_not raise_error
    end

    it "should not raise an error for a zero param" do
      lambda { BaseTestHelper.generate({ :first_name => "First", :last_name => "Last", :age => "0" }) }.should_not raise_error
    end

    it "should respect :on setting" do
      lambda { BaseTestHelper.receive({ :first_name => "First", :base_type => "contact", :age => "42" }) }.should_not raise_error
    end

  end

  describe "type casting" do

    before do
      @data = "flibby"
      @result = BaseTestHelper.receive({ :first_name => "First", :last_name => "Last", :age => "42", :base_type => "contact", :data => @data })
    end

    it "should cast integers" do
      @result.age.should == 42
    end

    it "should cast symbols" do
      @result.base_type.should == :contact
    end

    it "should leave alone" do
      @result.data.should == @data
    end

  end

end
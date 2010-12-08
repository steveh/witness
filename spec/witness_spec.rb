require "spec_helper"

describe Witness do

  describe "update url" do

    it "should update a basic url" do
      url = "http://www.example.com/index?colour=black"
      params = { :noise => "meow", "animal" => :cat }

      Witness.update_url(url, params).should == "http://www.example.com/index?animal=cat&colour=black&noise=meow"
    end

    it "should update a url with arrays" do
      url = "http://www.example.com/index?colour[]=black&colour[]=white&cutlery[knife]=1&cutlery[fork]=1"
      params = { :noise => "meow", "animal" => :cat, :cutlery => { :spoon => 1 } }

      Witness.update_url(url, params).should == "http://www.example.com/index?animal=cat&colour[]=black&colour[]=white&cutlery[spoon]=1&noise=meow"
    end

    it "should update a url wihout a trailing slash" do
      url = "http://www.example.com"
      params = { :noise => "meow" }

      Witness.update_url(url, params).should == "http://www.example.com/?noise=meow"
    end

    it "should update a url with a trailing ?" do
      url = "http://www.example.com/?"
      params = { :noise => "meow" }

      Witness.update_url(url, params).should == "http://www.example.com/?noise=meow"
    end

    it "should update a url without http" do
      url = "www.example.com/?"
      params = { :noise => "meow" }

      Witness.update_url(url, params).should == "http:www.example.com/?noise=meow"
    end

    it "should rescue with nil given invalid parameters" do
      url = "www.example.com/?"
      params = ["cat"]

      Witness.update_url(url, params).should == nil
    end

  end

end
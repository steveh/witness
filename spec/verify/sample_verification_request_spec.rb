require "spec_helper"

describe SampleVerificationRequest do

  it "should not allow initialization" do
     SampleVerificationRequest.new.should raise_error
  end

  describe "generate" do

    before do
      @valid_generate_params = {
        :cas_host => "cas.local",
        :slice_slug => "banana",
        :secure_area_id => 42,
        :request_url => "http://www.example.com/secure",
        :receive_contact_url => "http://www.example.com/receive?cat=meow",
        :receive_login_url => "http://www.example.com/login?cat=meow",
      }

      @valid_params = @valid_generate_params.dup
      @valid_params.delete(:cas_host)
    end

    describe "initialization" do

      it "should generate" do
        SampleVerificationRequest.generate(@valid_generate_params)
      end

      it "should raise an error if cas host is not set" do
        @valid_generate_params.delete(:cas_host)
        lambda { SampleVerificationRequest.generate(@valid_generate_params) }.should raise_error(Verify::Error, /CAS host not set/)
      end

      it "should raise an error if Slice slug is not set" do
        @valid_generate_params.delete(:slice_slug)
        lambda { SampleVerificationRequest.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Slice not set/)
      end

      it "should raise an error if Secure Area ID is not set" do
        @valid_generate_params.delete(:secure_area_id)
        lambda { SampleVerificationRequest.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Secure Area ID not set/)
      end

      it "should raise an error if Request URL is not set" do
        @valid_generate_params.delete(:request_url)
        lambda { SampleVerificationRequest.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Request URL not set/)
      end

      it "should raise an error if Receive Contact URL is not set" do
        @valid_generate_params.delete(:receive_contact_url)
        lambda { SampleVerificationRequest.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Receive Contact URL not set/)
      end

      it "should raise an error if Receive Login URL is not set" do
        @valid_generate_params.delete(:receive_login_url)
        lambda { SampleVerificationRequest.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Receive Login URL not set/)
      end

    end

    describe "parameters" do

      it "should generate parameters" do
        request = SampleVerificationRequest.generate(@valid_generate_params)
        request.params.should == @valid_params
      end

    end

    describe "url" do

      it "should generate a url" do
        request = SampleVerificationRequest.generate(@valid_generate_params)
        request.url.should == "http://cas.local/cas/contact/verify?receive_contact_url=http%3A%2F%2Fwww.example.com%2Freceive%3Fcat%3Dmeow&receive_login_url=http%3A%2F%2Fwww.example.com%2Flogin%3Fcat%3Dmeow&request_url=http%3A%2F%2Fwww.example.com%2Fsecure&secure_area_id=42&slice_slug=banana"
      end

    end

  end

  describe "receive" do

    before do
      @valid_generate_params = {
        :slice_slug => "banana",
        :secure_area_id => 42,
        :request_url => "http://www.example.com/secure",
        :receive_contact_url => "http://www.example.com/receive?cat=meow",
        :receive_login_url => "http://www.example.com/login?cat=meow",
      }
    end

    describe "initialization" do

      it "should generate" do
        SampleVerificationRequest.receive(@valid_generate_params)
      end

      it "should raise an error if Slice slug is not set" do
        @valid_generate_params.delete(:slice_slug)
        lambda { SampleVerificationRequest.receive(@valid_generate_params) }.should raise_error(Verify::Error, /Slice not set/)
      end

      it "should raise an error if Secure Area ID is not set" do
        @valid_generate_params.delete(:secure_area_id)
        lambda { SampleVerificationRequest.receive(@valid_generate_params) }.should raise_error(Verify::Error, /Secure Area ID not set/)
      end

      it "should raise an error if Request URL is not set" do
        @valid_generate_params.delete(:request_url)
        lambda { SampleVerificationRequest.receive(@valid_generate_params) }.should raise_error(Verify::Error, /Request URL not set/)
      end

      it "should raise an error if Receive Contact URL is not set" do
        @valid_generate_params.delete(:receive_contact_url)
        lambda { SampleVerificationRequest.receive(@valid_generate_params) }.should raise_error(Verify::Error, /Receive Contact URL not set/)
      end

      it "should raise an error if Receive Login URL is not set" do
        @valid_generate_params.delete(:receive_login_url)
        lambda { SampleVerificationRequest.receive(@valid_generate_params) }.should raise_error(Verify::Error, /Receive Login URL not set/)
      end

    end

  end

end
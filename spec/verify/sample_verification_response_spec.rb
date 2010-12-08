require "spec_helper"

describe SampleVerificationResponse do

  it "should not allow initialization" do
     SampleVerificationResponse.new.should raise_error
  end

  describe "generate" do

    before do
      @valid_generate_params = {
        :slice_slug => "banana",
        :secure_area_id => 42,
        :request_url => "http://www.example.com/secure",
        :receive_contact_url => "http://www.example.com/receive?cat=meow",
        :receive_login_url => "http://www.example.com/login?cat=meow",
        :contact_id => 1234,
        :authorized => true,
        :key => "deadbeef",
      }

      @valid_params = @valid_generate_params.dup
      @valid_params.delete(:key)
      @valid_params.delete(:receive_contact_url)
      @valid_params.delete(:receive_login_url)
      @valid_params[:signature] = "ffb581dbdf4d72f2c3c4d61af2fbaaa6fbcf66af"
    end

    describe "initialization" do

      it "should generate" do
        SampleVerificationResponse.generate(@valid_generate_params)
      end

      it "should raise an error if Slice slug is not set" do
        @valid_generate_params.delete(:slice_slug)
        lambda { SampleVerificationResponse.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Slice not set/)
      end

      it "should raise an error if Request URL is not set" do
        @valid_generate_params.delete(:request_url)
        lambda { SampleVerificationResponse.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Request URL not set/)
      end

      it "should raise an error if Receive Contact URL is not set" do
        @valid_generate_params.delete(:receive_contact_url)
        lambda { SampleVerificationResponse.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Receive Contact URL not set/)
      end

      it "should raise an error if Contact ID is not set" do
        @valid_generate_params.delete(:contact_id)
        lambda { SampleVerificationResponse.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Contact ID not set/)
      end

      it "should raise an error if Key is not set" do
        @valid_generate_params.delete(:key)
        lambda { SampleVerificationResponse.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Key not set/)
      end

      it "should recognise true authorizations" do
        @valid_generate_params[:authorized] = true
        response = SampleVerificationResponse.generate(@valid_generate_params)
        response.authorized.should == true

        @valid_generate_params[:authorized] = "true"
        response = SampleVerificationResponse.generate(@valid_generate_params)
        response.authorized.should == true

        @valid_generate_params[:authorized] = 1
        response = SampleVerificationResponse.generate(@valid_generate_params)
        response.authorized.should == true

        @valid_generate_params[:authorized] = "1"
        response = SampleVerificationResponse.generate(@valid_generate_params)
        response.authorized.should == true
      end

      it "should recognise false authorizations" do
        @valid_generate_params[:authorized] = false
        response = SampleVerificationResponse.generate(@valid_generate_params)
        response.authorized.should == false

        @valid_generate_params[:authorized] = "false"
        response = SampleVerificationResponse.generate(@valid_generate_params)
        response.authorized.should == false

        @valid_generate_params[:authorized] = 0
        response = SampleVerificationResponse.generate(@valid_generate_params)
        response.authorized.should == false

        @valid_generate_params[:authorized] = "0"
        response = SampleVerificationResponse.generate(@valid_generate_params)
        response.authorized.should == false
      end

      it "should deny invalid authorizations" do
        @valid_generate_params[:authorized] = "meow"
        lambda { SampleVerificationResponse.generate(@valid_generate_params) }.should raise_error(Verify::Error, /Authorization not valid/)
      end

    end

    describe "parameters" do

      it "should generate parameters" do
        request = SampleVerificationResponse.generate(@valid_generate_params)
        request.params.should == @valid_params
      end

    end

    describe "url" do

      it "should generate a url" do
        request = SampleVerificationResponse.generate(@valid_generate_params)
        request.url.should == "http://www.example.com/receive?authorized=true&cat=meow&contact_id=1234&request_url=http%3A%2F%2Fwww.example.com%2Fsecure&secure_area_id=42&signature=ffb581dbdf4d72f2c3c4d61af2fbaaa6fbcf66af&slice_slug=banana"
      end

    end

  end

  describe "receive" do

    before do
      @valid_generate_params = {
        :slice_slug => "banana",
        :secure_area_id => 42,
        :request_url => "http://www.example.com/secure",
        :contact_id => 1234,
        :authorized => true,
        :key => "deadbeef",
        :signature => "ffb581dbdf4d72f2c3c4d61af2fbaaa6fbcf66af",
      }
    end

    describe "initialization" do

      it "should generate" do
        SampleVerificationResponse.receive(@valid_generate_params)
      end

      it "should raise an error if Slice slug is not set" do
        @valid_generate_params.delete(:slice_slug)
        lambda { SampleVerificationResponse.receive(@valid_generate_params) }.should raise_error(Verify::Error, /Slice not set/)
      end

      it "should raise an error if Request URL is not set" do
        @valid_generate_params.delete(:request_url)
        lambda { SampleVerificationResponse.receive(@valid_generate_params) }.should raise_error(Verify::Error, /Request URL not set/)
      end

      it "should raise an error if Signature is not set" do
        @valid_generate_params.delete(:signature)
        lambda { SampleVerificationResponse.receive(@valid_generate_params) }.should raise_error(Verify::Error, /Signature not set/)
      end

      it "should raise an error if Signature does not match" do
        @valid_generate_params[:signature] = "incorrect"
        lambda { SampleVerificationResponse.receive(@valid_generate_params) }.should raise_error(Verify::Error, /Signature does not match/)
      end

    end

  end

end
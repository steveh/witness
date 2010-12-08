class SampleVerificationResponse < Witness::Base

  action :generate, :receive

  column :slice_slug, :name => "Slice"
  column :secure_area_id, :type => :integer, :name => "Secure Area ID"
  column :request_url, :name => "Request URL"
  column :receive_contact_url, :name => "Receive Contact URL"
  column :contact_id, :type => :integer, :name => "Contact ID"
  column :authorized, :type => :boolean, :name => "Authorization"
  column :key

  validates_presence_of :slice_slug, :request_url, :contact_id, :key
  validates_presence_of :receive_contact_url, :on => :generate

  attr_accessor :signature

  def url
    Witness.update_url(receive_contact_url, params)
  end

  def secure_params
    {
      :slice_slug => slice_slug,
      :contact_id => contact_id,
      :secure_area_id => secure_area_id,
      :authorized => authorized,
      :request_url => request_url,
      :signature => signature,
    }.reject { |k, v| v.nil? }
  end

  def params
    _params = secure_params
    sigil = Sigil::Base.new(_params, key)
    _params.update(:signature => sigil.signature).reject { |k, v| v.nil? }
  end

  def self.construct(provided_params)
    response = super(provided_params)

    command = provided_params[:command]

    if command == :receive
      if provided_params[:signature].blank?
        raise Witness::Error, "Signature not set"
      end

      sigil = Sigil::Base.new(response.secure_params, response.key)

      verified = sigil.verify(provided_params[:signature])

      if !verified
        raise Witness::Error, "Signature does not match"
      end

    end

    response
  end

end
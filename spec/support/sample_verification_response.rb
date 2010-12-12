class SampleVerificationResponse < Witness::Base

  action :generate, :receive

  column :slice_slug, :name => "Slice"
  column :secure_area_id, :type => :integer, :name => "Secure Area ID"
  column :request_url, :name => "Request URL"
  column :receive_contact_url, :name => "Receive Contact URL"
  column :contact_id, :type => :integer, :name => "Contact ID"
  column :authorized, :type => :boolean, :name => "Authorization"

  validates_presence_of :slice_slug, :request_url, :contact_id
  validates_presence_of :receive_contact_url, :on => :generate

  validates_signature_of :slice_slug, :contact_id, :secure_area_id, :authorized, :request_url, :on => :receive

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

end
class SampleVerificationRequest < Verify::Base

  action :generate, :receive

  column :cas_host, :name => "CAS host"
  column :slice_slug, :name => "Slice"
  column :secure_area_id, :type => :integer, :name => "Secure Area ID"
  column :request_url, :name => "Request URL"
  column :receive_contact_url, :name => "Receive Contact URL"
  column :receive_login_url, :name => "Receive Login URL"

  validates_presence_of :slice_slug, :secure_area_id, :request_url, :receive_contact_url, :receive_login_url
  validates_presence_of :cas_host, :on => :generate

  def url
    Verify.update_url("http://#{cas_host}/cas/contact/verify", params)
  end

  def params
    {
      :slice_slug => slice_slug,
      :secure_area_id => secure_area_id,
      :request_url => request_url,
      :receive_contact_url => receive_contact_url,
      :receive_login_url => receive_login_url,
    }.reject { |k, v| v.nil? }
  end

end
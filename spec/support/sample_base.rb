class SampleBase < Witness::Base

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
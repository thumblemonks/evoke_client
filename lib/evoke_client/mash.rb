module Enumerable
  # Let's you do stuff like:
  #
  #   hashed_users = [:id, :name].mash {|attr| {attr => attr.to_s} }
  #   => {:id => 'id', :name => 'name'}
  def mash
    self.inject({}) { |a,i| a.merge( yield(i) ) }
  end
end

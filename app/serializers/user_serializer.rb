class UserSerializer < ApplicationSerializer
  attributes :id, :email, :password

  def id
    object.id.to_s
  end
end
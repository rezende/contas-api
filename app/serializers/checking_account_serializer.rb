class CheckingAccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :current_balance
end

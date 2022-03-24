class BusinessUserConnection < ApplicationRecord
  enum role: { owner: 0, admin: 1, staff: 2 }

  belongs_to :business_user
  belongs_to :business
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :assignments
  has_many :notes, dependent: :destroy
  has_and_belongs_to_many :accounts
  accepts_nested_attributes_for :accounts
  attribute_choices :user_role ,  [['admin', 'Admin'], ['sv', 'Supervisor'], ['art', 'Artist']]
end

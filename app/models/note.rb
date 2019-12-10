class Note < ApplicationRecord
  belongs_to :project
  belongs_to :user

  delegate :name, to: :user, prefix: true

  validates :message, presence: true

  # LOWERはmessageカラムの文字列を全て小文字にする
  scope :search, ->(term) {
    where("LOWER(message) Like ?", "%#{term.downcase}%")
  }

  has_attached_file :attachment

  validates_attachment :attachment,
    content_type: {
      content_type: [
        "image/jpeg",
        "image/gif",
        "image/png",
        "application/pdf",
      ],
    }
end

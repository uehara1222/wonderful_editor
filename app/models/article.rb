class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy

  validates :title, presence: true, if: :draft?
  validates :title, :body, presence: true, if: :published?

  enum status: { draft: 0, published: 1 }

  def publish
    update(status: :published)
  end

  def draft?
    status == "draft"
  end

  def published?
    status == "published"
  end
end

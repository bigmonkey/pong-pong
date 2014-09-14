# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
		sequence(:title) { |n| "Article Title #{n}" }
		sequence(:author) { |n| "Author#{n}"}
		sequence(:author_url) { |n| "https://www.xerpi.com" } 
		sequence(:article) { |n| "Be careful with payday loans. They have high rates. This is article #{n} on payday loans" }
		sequence(:seo_title) { |n| "SEO Article Title #{n}"}
		sequence(:description) { |n| "Article #{n} description"}
		sequence(:slug) { |n| "article-slug-#{n}"}
  end
end

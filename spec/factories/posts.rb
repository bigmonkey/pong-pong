# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
		sequence(:title) { |n| "Post Title #{n}" }
		sequence(:author) { |n| "Author#{n}"}
		sequence(:author_url) { |n| "https://www.xerpi.com" } 
		sequence(:article) { |n| "Be careful with payday loans. They have high rates. This is post #{n} on payday loans" }
		sequence(:seo_title) { |n| "SEO Post Title #{n}"}
		sequence(:description) { |n| "Post #{n} description"}
		sequence(:slug) { |n| "post-slug-#{n}"}  	
  end
end

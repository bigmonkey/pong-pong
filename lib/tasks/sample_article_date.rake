require 'faker'

namespace :db do
  desc "Create sample articles in database data"
  task populate: :environment do
    16.times do |n|
      title  = Faker::Lorem.words(4).join(" ")
      author = Faker::Name.name
      author_url = Faker::Internet.url
      article = "<p>"+Faker::Lorem.paragraph(10)+"</p>"+"<p>"+Faker::Lorem.paragraph(10)+"</p>"+"<p>"+Faker::Lorem.paragraph(10)+"</p>"+"<p>"+Faker::Lorem.paragraph(10)+"</p>"+"<p>"+Faker::Lorem.paragraph(10)+"</p>"
      seo_title = title
      description = Faker::Lorem.sentence(8)
      slug = title.gsub(" ","-")
      Article.create!(
      	title: title,
      	author: author,
      	author_url: author_url,
      	article: article,
      	seo_title: seo_title,
      	description: description,
      	slug: slug
      	)
    end	
  end
end
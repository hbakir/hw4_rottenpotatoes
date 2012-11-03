#Adding a step to populate the database
Given /^the following movies exist:$/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

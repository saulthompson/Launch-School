munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

=begin

algorithm:
  
  get only male members of nested hash (in a new, two-layer hash)
  call select, checking values only (nested hashes)
    value['gender'] == "male"
  end
  get array of ages from `males` hash
    
  sum the ages
=end

# males = munsters.select do |_, val|
#   val['gender'] == 'male'
# end

# ages = males.map do |_, val|
#   val["age"]
# end



# age_total = 0

# munsters.each_value do |value|
#   age_total += value["age"] if value["gender"] == "male"
# end

# munsters.each do |key, value|
#   puts "#{key} is a #{value["age"]}-year-old #{value["gender"]}."
# end


=begin

input: [{a: 1}, {b: 2, c: 3}, {d: 4, e: 5, f: 6}]

DS:
  array of hashes
  need to use map on the array, which returns an array of the same length
  need to use map on each of the hashes, will return a series of arrays
  need to convert those arrays back to hashes
  
Algo:
  
  access the hash values
    transform the array
  increment the hash values
  
  


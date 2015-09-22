require 'core_data'

path = ARGV.first

# path = '../PinguModel/Model.xcdatamodeld/Model 4.xcdatamodel'
model = ::CoreData::DataModel.new(path)

puts "\n"

model.entities.each do |entity|
  string = "rails destroy scaffold #{entity.name} -f -q\n"

  string += "rails g scaffold #{entity.name} "

  entity.attributes.each do |attribute|
    type = "#{attribute.type}"
    if (type == "Integer 16")
      type = "integer"
    end
    if (type == "Double")
      type = "float"
    end
    string += "#{attribute.name.downcase}:#{type.downcase} "
  end

  entity.relationships.each do |relation|
    if !relation.to_many?
      string += "#{relation.destination.downcase}:references "
    end
  end

  string += "-f -q"
  string += "\n"

  puts string
end

puts "rake db:drop\n"
puts "rake db:create\n"
puts "rake db:migrate\n\n"

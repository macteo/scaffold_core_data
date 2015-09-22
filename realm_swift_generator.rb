require 'core_data'

path = ARGV.first
model = ::CoreData::DataModel.new(path)

puts "// Create the Entity.swift file and paste this content"

puts "\n"
puts "import RealmSwift"
puts "\n"

model.entities.each do |entity|
  string = "\n"
  string += "class #{entity.name}: Object {\n"

  entity.attributes.each do |attribute|
    string += "    dynamic var #{attribute.name.downcase}"
    value = ""
    if attribute.default_value
      value = attribute.default_value
    end
    if attribute.type == "String"
      string += " = \"#{value}\"\n"
    elsif attribute.type == "Boolean"
      if value == true
        string += " = true\n"
      else
        string += " = false\n"
      end
    elsif attribute.type == "Date"
      if value != ""
        string += " = #{value}\n"
      else
        string += " = NSDate()\n"
      end
    else
      string += " = #{value}\n"
    end
  end
  string += "\n"

  entity.relationships.each do |relation|
    string += "    dynamic var #{relation.name.downcase} = "
    if relation.to_many?
      string += "List<#{relation.destination}>()\n"
    else
      if relation.optional?
        string += "#{relation.destination}?\n"
      else
        string += "#{relation.destination}()\n"
      end
    end

    # This is for inverse properties, but its computed, a shortcut basically
    # string += "    var #{relation.name.downcase}: [#{relation.destination}] {\n"
    # string += "        return linkingObjects(#{relation.destination}.self, forProperty: \"#{relation.inverse}\")\n"
    # string += "    }\n"

    string += "\n"
  end

  string += "    static func primaryKey() -> String? {\n"
  string += "        return \"id\"\n"
  string += "    }\n"

  string += "}\n"

  puts string
end

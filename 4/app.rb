require 'json'

module PersonInfo

    def magic_methods(*params)
      params.each do |param|
        define_method param do
          personal_data["#{param}"]
        end
      end
    end

end

RESPONSE = '{"person":{"personal_data":{"name": "John Smith", "gender":"male", "age":28},"social_profiles":["http://facebook....","http://twitter...","http://"], "family" : {"father":"John Smith", "mother":"Mary Lou"}, "additional_info":{"hobby":["pubsurfing","drinking","hiking"], "pets":[{"name":"Mittens","species":"Felis silvestris catus"}]}}}'

response = JSON.parse(RESPONSE)
p response["person"].keys.collect(&:to_sym)

Person = Struct.new(*response["person"].keys.collect(&:to_sym)) do

  extend PersonInfo

  def adult?
    (personal_data.include? 'age') && personal_data['age'] >= 18 ? 'adult person' : 'young person'
  end

  magic_methods :name, :gender, :age
  # magic_methods personal_data.keys.collect(&:to_sym)

end

person = Person.new(*response["person"].values)

p person.adult?
p person.name
p person.gender
p person.age

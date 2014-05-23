Shindo.tests("Fog::Compute[:clc] | image model", ['clc', 'compute']) do

  service = Fog::Compute[:clc]
  image  = service.images.first

  tests('The image model should') do
    tests('have the action') do
      test('reload') { image.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = image.attributes
      attributes = [
        :id,
        :name
      ]
      tests("The image model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { image.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end
  end

end


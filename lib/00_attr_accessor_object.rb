class AttrAccessorObject
  def self.my_attr_accessor(*names)

    names.each do |name|
      define_method(name) do
        instance_variable_get('@' + name.to_s)
        # self.name
      end

      define_method("#{name}=") do |val|
        instance_variable_set('@' + name.to_s, val)
        #self.name = val
      end
    end

    # names.each do |name|
    #   define_method("#{name}=") do
    #     self.name = object
    #   end
    # end

  end
end

# it 'getter methods get from associated ivars' do
#   x_val = 'value of @x'
#   y_val = 'value of @y'
#   obj.instance_variable_set('@x', x_val)
#   obj.instance_variable_set('@y', y_val)
#
#   expect(obj.x).to eq(x_val)
#   expect(obj.y).to eq(y_val)
# end
#
# it 'setter methods set associated ivars' do
#   x_val = 'value of @x'
#   y_val = 'value of @y'
#   obj.x = x_val
#   obj.y = y_val
#
#   expect(obj.instance_variable_get('@x')).to eq(x_val)
#   expect(obj.instance_variable_get('@y')).to eq(y_val)
# end

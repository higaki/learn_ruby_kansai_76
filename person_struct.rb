RUBY_DESCRIPTION # => "ruby 2.4.0preview1 (2016-06-20 trunk 55466) [x86_64-darwin14]"

Person = Struct.new(:name, :born)

matz = Person.new('matz')
dhh  = Person.new('dhh', Time.local(1979, 10, 15))

person = Marshal.load(Marshal.dump matz)

person == matz                  # => true
person == dhh                   # => false

h = {matz => "Ruby", dhh => "Rails"}

key = Marshal.load(Marshal.dump matz)

h[matz]                         # => "Ruby"
h[dhh]                          # => "Rails"

h[key]                          # => "Ruby"


class Person
  def age
    (Time.now.strftime('%Y%m%d').to_i - born.strftime('%Y%m%d').to_i) / 1_00_00
  end
end

dhh.age                         # => 37

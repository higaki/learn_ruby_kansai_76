RUBY_DESCRIPTION # => "ruby 2.4.0preview1 (2016-06-20 trunk 55466) [x86_64-darwin14]"

class Person; end # !> previous definition of Person was here

obj = Person.new          # => #<Person:0x007fb6b20c32d8>

obj.class                 # => Person
Person.superclass         # => Object


class Person
  def initialize(name) # !> previous definition of initialize was here
    @name = name
  end
end

matz = Person.new('matz') # => #<Person:0x007fb6b20c2018 @name="matz">

class Person
  attr_reader :name
end

matz.name                 # => "matz"


class Person
  def initialize(name, born = nil) # !> method redefined; discarding old initialize
    @name, @born = name, born
  end
  attr_accessor :born
end

matz.methods.map(&:to_s).grep(/born/)  # => ["born", "born="]

matz.born = Time.local(1965, 4, 14)
dhh = Person.new('dhh', Time.local(1979, 10, 15))

matz.born                       # => 1965-04-14 00:00:00 +0900
dhh.born                        # => 1979-10-15 00:00:00 +0900


class Person
  def age
    (Time.now.strftime('%Y%m%d').to_i - @born.strftime('%Y%m%d').to_i) / 1_00_00
  end
end

matz.age                        # => 51
dhh.age                         # => 37


matz.to_s                       # => "#<Person:0x007fb6b20c2018>"

class Person
  def to_s
    "#{@name}(#{age})"
  end
end

matz.to_s                       # => "matz(51)"
dhh.to_s                        # => "dhh(37)"

class Person
  def inspect
    to_s
  end
end

person = Marshal.load(Marshal.dump matz) # => matz(51)

person == dhh                   # => false
person == matz                  # => false


class Person
  include Comparable
  def <=> o
    @name <=> o.name
  end
end

person == dhh                   # => false
person == matz                  # => true
matz > dhh                      # => true


people = [matz, dhh]

people.sort                     # => [dhh(37), matz(51)]


people.sort_by(&:age)           # => [dhh(37), matz(51)]


people.sort_by{|p| -p.age}      # => [matz(51), dhh(37)]
people.sort_by(&:born)          # => [matz(51), dhh(37)]


h = {matz => "Ruby", dhh => "Rails"}

h[matz]                         # => "Ruby"
h[dhh]                          # => "Rails"

key = Marshal.load(Marshal.dump matz)

key == matz                     # => true
h[key]                          # => nil


class Person
  def hash
    [@name, @born].hash
  end
end

matz.hash                       # => 3418663135155136629
dhh.hash                        # => -3356620362636648116
key.hash                        # => 3418663135155136629


class Person
  def eql? o
    [@name, @born].eql? [o.name, o.born]
  end
end

key.eql? matz                   # => true
key.eql? dhh                    # => false


h.rehash

h[matz]                         # => "Ruby"
h[dhh]                          # => "Rails"

h[key]                          # => "Ruby"

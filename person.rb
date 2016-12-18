class Person
  include Comparable

  def initialize(name, born = nil)
    @name, @born = name, born
  end

  attr_reader :name
  attr_accessor :born

  def age
    (Time.now.strftime('%Y%m%d').to_i - @born.strftime('%Y%m%d').to_i) / 1_00_00
  end

  def to_s
    "#{@name}(#{age})"
  end

  def <=> o
    @name <=> o.name
  end

  def hash
    [@name, @born].hash
  end

  def eql? o
    [@name, @born].eql? [o.name, o.born]
  end
end

if $0 == __FILE__
  matz = Person.new('matz')
  matz.born = Time.local(1965, 4, 14)
  dhh  = Person.new('dhh', Time.local(1979, 10, 15))

  matz.age                      # => 51
  dhh.age                       # => 37

  class Person
    def inspect; to_s end
  end

  person = key = Marshal.load(Marshal.dump matz)

  person == dhh                 # => false
  person == matz                # => true
  matz > dhh                    # => true

  people = [matz, dhh]

  people.sort                   # => [dhh(37), matz(51)]
  people.sort_by(&:age)         # => [dhh(37), matz(51)]
  people.sort_by{|p| -p.age}    # => [matz(51), dhh(37)]
  people.sort_by(&:born)        # => [matz(51), dhh(37)]

  h = {matz => "Ruby", dhh => "Rails"}
  h[matz]                       # => "Ruby"
  h[dhh]                        # => "Rails"
  h[key]                        # => "Ruby"

  matz.hash                     # => -1547007935513140231
  dhh.hash                      # => 3891399111051439359
  key.hash                      # => -1547007935513140231

  key.eql? matz                 # => true
  key.eql? dhh                  # => false
end

require 'pry'

class AmnestyEntity
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end
end

class AmnestyPosition < AmnestyEntity
end

class FieldOrganizer < AmnestyPosition
  @@field_organizers = []

  attr_accessor :region, :acs, :sacs

  def initialize(name, region)
    @name = name
    @region = region
    region = Region.all.detect { |region| region.name == @region }
    region.field_organizers << self
    @acs = []
    @sacs = []
    @@field_organizers << self
  end

  def self.all
    @@field_organizers
  end
end

class AreaCoordinator < AmnestyPosition
  @@area_coordinators = []

  attr_accessor :field_organizer

  def initialize(name, field_organizer)
    @name = name
    @field_organizer = FieldOrganizer.all.detect { |fo| fo.name == field_organizer }
    @@area_coordinators << self
    binding.pry if @field_organizer.nil?
    @field_organizer.acs << self
  end

  def region
    field_organizer.region
  end

  def self.all
    @@area_coordinators
  end
end

class Region < AmnestyEntity
  @@regions = []

  attr_reader :field_organizers

  def initialize(name)
    @name = name
    @field_organizers = []
    @@regions << self
  end

  def to_s
    "#{name} Region"
  end

  def self.all
    @@regions
  end

  def number_of_field_organizers
    # if name == "Western" then "NOT ENOUGH! WE NEED MORE FIELD ORGANIZERS!" end
    field_organizers.count
  end
end

class AmnestyStructure
  attr_accessor :regions

  def initialize
    self.regions = []
  end

  def build_structure
    add_regions("Midwest", "Mid-Atlantic", "Northeast", "Southern", "Western")

    # midwest = Region.new("Midwest")
    # midatlantic = Region.new("Mid-Atlantic")
    # northeast = Region.new("Northeast")
    # southern = Region.new("Southern")
    # western = Region.new("Western")

    add_fos_by_region("Midwest" => ["Ernest Coverson", "Carolina Rivandeira"],
            "Mid-Atlantic" => ["Savannah Fox"],
            "Northeast" => ["Cynthia Gabriel Walsh", "Julie Southwell"],
            "Western" => ["Will Butkus", "Muna Sharif"],
            "Southern" => ["Ebony Brickhouse", "Taliba Obuya"])

    add_acs_by_fo({ "Savannah Fox" => ["Nick Geballe", "Eve Wider", "Kathleen Lucas"],
      "Carolina Rivandeira" => ["Laura Osborn-Coffey", "Mary Sand", "Aaron Tovo", "Susan F. Mitchell"],
      "Ernest Coverson" => ["Blaine Mineman", "Tom Benner", "Kenneth Grunow", "Emily Beck"] })

    regions = Region.all

    field_organizers = FieldOrganizer.all
    regions.each do |region|
      puts "#{region} (#{region.field_organizers.size})"
      region.field_organizers.each do |fo|
        puts fo
        fo.acs.each do |ac|
          puts "- #{ac}"
        end
        puts
      end
    end

    # add_fos_to_region("Midwest", "Ernest Coverson", "Carolina Rivandeira")
    # add_fos_to_region("Mid-Atlantic", "Savannah Fox", "Cynthia Gabriel")
    # add_fos_to_region("Midwest", "Ernest Coverson", "Carolina Rivandeira")
    # add_fos_to_region("Midwest", "Ernest Coverson", "Carolina Rivandeira")
    # add_fos_to_region("Midwest", "Ernest Coverson", "Carolina Rivandeira")
  end

  def add_regions(*region_names)
    region_names.each do |name|
      @regions << Region.new(name)
    end
  end

  def add_fos_by_region(region_fo_hash)
    region_fo_hash.each do |region_name, fo_names|
      fo_names.each do |fo_name|
        FieldOrganizer.new(fo_name, region_name)
      end
    end
  end

  def add_acs_by_fo(fo_ac_hash)
    fo_ac_hash.each do |fo_name, ac_names|
      ac_names.each do |ac_name|
        AreaCoordinator.new(ac_name, fo_name)
      end
    end
  end
end

AmnestyStructure.new.build_structure

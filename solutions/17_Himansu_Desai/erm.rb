require 'stringio'
require "rexml/document"
include REXML

# Method on Kernel gives the ability to have a poor man's DSL like
# definition of an Entity-Relationship model.
module Kernel
  def define_erm_schema(name, &blk)
    ERM.create(name, &blk)
  end
end

# Attribute Type definitions are hooked up inside the ERM data
# structure and used to convert xml strings to the appropriate
# ruby format
class AttrType
  def convert string_val
    string_val
  end
end
class AttrTypeInteger < AttrType
  def convert string_val
    string_val.to_i
  end
end
class AttrTypeFloat < AttrType
  def convert string_val
    string_val.to_f
  end
end

# Entity Relationship Model.  Represents only a *subset* of an xml file, that a
# client is interested in
# This is not a full featured implementation in that it only supports Entities,
# Attributes and one kind of Relationship, needed for this RPCFN assignment
class ERM
  attr_reader :name, :entities, :relationships, :instances
  # This class method is used in conjuction with the define_erm_schema method on
  # Kernel
  def self.create(name, &blk)
    erm = self.new(name)
    erm.instance_eval(&blk)
    erm
  end
  
  # Define an Entity
  def entity(name, attrs)
    @entities << Entity.new(name, attrs)
    ERM.class_eval do 
      define_method name do
        @instances[name]
      end
    end
  end

  # Define a one to many relationship
  def one_to_many_relationship(rel_name, definition)
    @relationships << OneToManyRelationship.new(rel_name, definition)
  end

  # Parse an xml file according to the definition of this ERM
  def parse filename
    doc = Document.new(File.new(filename))
    elements = doc.elements
    # Let each entity definition do it's own lower level parsing
    self.entities.each do |e|
      @instances[e.name] = e.parse(self, elements)
    end
    # Let each relationship definition do it's own lower level parsing
    self.relationships.each do |r|
      r.parse(self, @instances)
    end
  end

  # instances are stored by type, after parsing
  def instances(type)
    @instances[type]
  end

  def initialize(name)
    @name = name
    @entities = []
    @relationships = []
    @instances = {}
  end
end

# Represents the Entity part of ERM.  Has a name and attributes
class Entity
  attr_accessor :name, :attributes

  @@attr_types = {:string => AttrType.new, :integer => AttrTypeInteger.new, :float => AttrTypeFloat.new}

  def initialize name, attrs
    @name = name
    @attributes = {}
    attrs.each_pair {|name, type| @attributes[name] = @@attr_types[type]}

    # Dynamically create a class with the name of the Entity, that is a
    # subclass of our data-driven, generic class 'Instance'
    attrs = self.attributes
    c_name = self.name.capitalize.to_s
    # Below line is questionable in that a user defined string (name) is evaluated
    # I'm not sure of a different, safer way to dynamically create a class.  
    # Perhaps multiple checks on c_name, for irregularities before passing it 
    # through this code might help
    Object.class_eval "class #{c_name} < Instance; end"
    klas = Object.const_get(c_name)
    klas.class_eval do       
      # for each attribute on the Entity, define a method with that
      # name on the newly created class
      attrs.each_pair do |a_name, a_type| 
        define_method a_name do
          @val[a_name.to_s]
        end
      end
    end
  end
  
  # Parse xml elements corresponding to this one entity definition, into ruby 
  # object instances of the correct subclass of 'Instance'
  def parse(erm, elements)        
    klas = Object.const_get(self.name.capitalize.to_s)
    elements.to_a("#{erm.name}/#{self.name}").collect {|xml_ele| klas.new(self, xml_ele)}
  end

  def to_s
    s = StringIO.new
    s << "Entity #{name} with attrs: "; self.attributes.each_pair {|k, v| s << "#{k}:#{v},"}
    s.string
  end
end

# Represents (one of many variations of) the Relationship part of ERM.  It has 
# source and target classes and public/foreign keys to do the mapping
class OneToManyRelationship
  attr_accessor :name, :src, :tar, :pk, :fk
  
  def initialize name, definition
    @name = name
    @src, @tar, @pk, @fk = definition[:source_class], definition[:target_class], definition[:primary_key], definition[:foreign_key]

    c_name = @src.capitalize.to_sym
    m_name = @name
    # Define a method with the name of the relationship, on the source class
    # that accesses the generic 'get_targets' method of the superclass 'Instance'
    klas = Object.const_get(c_name)
    klas.class_eval do       
      define_method m_name.to_sym do
        get_targets(m_name.to_s)
      end
    end

  end

  # For relationships, the raw parsing of xml elements into ruby instances
  # is already assumed to be done. So we only need to hook up the instances
  # according to the relationship definition (pk, fk, src and tar)
  def parse(erm, instances)
    instances[@src].each do |src|
      instances[@tar].each do |tar|
        src.add_target(@name, tar) if tar.val(@fk) == src.val(@pk)
      end
    end    
  end
end

# Represents an instance of an Entity 'type'. It is the data 
# corresponding to the schema definition
class Instance

  def initialize (entity_definition, xml_element)
    @val = {}
    @rels = {}
    @entity_definition = entity_definition
    entity_definition.attributes.each_pair { |a_name, a_type| @val[a_name.to_s] = a_type.convert((xml_element.attributes)[a_name.to_s]) }
  end

  def val attr_name
    @val[attr_name]
  end
  
  def add_target(link_name, target)
    @rels[link_name] ||= []
    @rels[link_name] << target
  end
  
  def get_targets(link_name)
    @rels[link_name]
  end
end
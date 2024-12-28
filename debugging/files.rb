#In this version of the code, there's a NameError that occurs when the program is run.
#The error complains of an `uninitialized constant File::FORMAT.`

#What's the problem, and what are possible ways to fix it?

class File
  attr_accessor :name, :byte_content

  def initialize(name)
    @name = name
  end

  alias_method :read,  :byte_content
  alias_method :write, :byte_content=

  def copy(target_file_name)
    target_file = self.class.new(target_file_name)
    target_file.write(read)

    target_file
  end

  def to_s
    "#{name}.#{FORMAT}"
  end
end

class MarkdownFile < File
  FORMAT = :md
end

class VectorGraphicsFile < File
  FORMAT = :svg
end

class MP3File < File
  FORMAT = :mp3
end

# Test

blog_post = MarkdownFile.new('Adventures_in_OOP_Land')
blog_post.write('Content will be added soon!'.bytes)

copy_of_blog_post = blog_post.copy('Same_Adventures_in_OOP_Land')

puts copy_of_blog_post.is_a? MarkdownFile     # true
puts copy_of_blog_post.read == blog_post.read # true

puts blog_post

#The constant `FORMAT` is initialized outside of the `File` class, then it's used
#inside the `File#to_s` class.
#When Ruby resolves a constant, it looks it up in its lexical scope.
#This means that it will look for the object referenced by the variable
#within the class where it's referenced. Then it will move up the inheritance chain.
#Since `MarkDownFile` is a subclass of `File`, Ruby won't "find" the constant and
#will raise a NameError.

#This can be fixed by updating the `File#to_s` method to this:

def to_s
  "#{name}.#{self.class::FORMAT}"
end

#Calling the `class` method on self will prepend the class name 
#which is determined by the subclass from which `to_s` is being called.

#You can also use a method, rather than a constant. Like this:

# class File
#   # code omitted

#   def to_s
#     "#{name}.#{format}"
#   end
# end

# class MarkdownFile < File
#   def format
#     :md
#   end
# end

# class VectorGraphicsFile < File
#   def format
#     :svg
#   end
# end

# class MP3File < File
#   def format
#     :mp3
#   end
# end
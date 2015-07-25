module CrystalScad
	class CrystalScadObject
		attr_accessor :args		
    attr_accessor :transformations
		def initialize(*args)
			@transformations = []
			@args = args.flatten
			if @args[0].kind_of? Hash
				@args = @args[0]			
			end		
		end

		def rounded_args args=@args
			case args
			when Hash
				args.each_with_object({}) {|(k,v), hash| hash[k] = rounded_args(v)}
			when Array
				args.map{|i| rounded_args(i)}
			else
				rounded_value args
			end
		end

		def rounded_value value
			if value.is_a? Float
				value.round(9) # rounding to nearest digit, to cut floating point error
			else
				value
			end
		end

		def walk_tree
			res = ""			
			
			@transformations.reverse.each{|trans|
				res += trans.walk_tree 
			}
			res += self.to_rubyscad.to_s+ "\n"
			res
		end
		alias :scad_output :walk_tree		
		
		def walk_tree_classes
			res = []
			@transformations.reverse.each{|trans|
				res += trans.walk_tree_classes 
			}
			res << self.class
			res
		end

		def to_rubyscad
			""
		end
		
		def save(filename,start_text=nil)
      file = File.open(filename,"w")
      file.puts start_text unless start_text == nil
      file.puts scad_output
      file.close		
		end
	end
end

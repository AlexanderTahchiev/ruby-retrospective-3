module Asm
  def self.asm (&block)
    Evaluator.new.instance_eval &block
    Evaluator.class_variable_get('@@registers').values
  end

  def method_missing(name, *args)
    name.to_s
  end

  def execute_instruction (where)
    if (where)
      original_queue = @operations_queue
      method(@operations_queue[where][0]).call(*@operations_queue[where].drop(1))
    else
    end
  end

  def execute_instruction_queue (where)
    original_queue = @operations_queue.dup
    @operations_queue.drop(@operations_queue.keys.index(where)).
      map{|i| i.drop(1).flatten}.select{|i| i.length != 1}.
      each{|i| execute_instruction (where)}
    @operations_queue = original_queue
  end
end

class Evaluator
  attr_accessor :ax, :bx, :cx, :dx
  def initialize()
    @@registers = {'ax' => 0, 'bx' => 0, 'cx' => 0, 'dx' => 0}
    @ax, @bx ,@cx, @dx = 'ax', 'bx', 'cx', 'dx'
    @operations_queue = {}
    @instruction_number = 0
    @last_compare = -1
    @jump_key = 0
  end

  def mov (destination_register, source)
    if (@jump_key == @instruction_number)
      @instruction_number += 1
      @jump_key += 1
      @operations_queue[@instruction_number] = [ :mov , destination_register, source ]
      if source.class == String
        @@registers[destination_register] = @@registers[source]
      else
        @@registers[destination_register] = source
      end
    end
  end

  def inc (destination_register, value = 1)
    if (@jump_key == @instruction_number)
      @instruction_number += 1
      @jump_key += 1
      @operations_queue[@instruction_number] = [ :inc, destination_register, value ]
      if value.class == String
        @@registers[destination_register] += @@registers[value]
      else
        @@registers[destination_register] = @@registers[destination_register] + value
      end
    end
  end

  def dec (destination_register, value = 1)
    if (@jump_key == @instruction_number)
      @instruction_number += 1
      @jump_key += 1
      @operations_queue[@instruction_number] = [ :dec, destination_register, value ]
      if value.class == String
        @@registers[destination_register] -= @@registers[value]
      else
        @@registers[destination_register] = @@registers[destination_register] - value
      end
    end
  end

  def cmp (register, value)
    if (@jump_key == @instruction_number)
      @instruction_number += 1
      @jump_key += 1
      @last_compare = @instruction_number
      @operations_queue[@instruction_number] = [ :cmp, register, value ]
      if value.class == String
        @@registers[register] <=> @@registers[value]
      else
        @@registers[register] <=> value
      end
    end
  end

  def label (label_name)
    label_name = label_name
    @operations_queue[label_name] = @instruction_number + 1
    if (@jump_key == label_name)
      execute_instruction_queue(label_name)
    end
  end

  def jmp (where)
    where = where
      if (where.class == String and @operations_queue[where])
        @jump_key = where
        execute_instruction_queue (@operations_queue[where])
      elsif (where.class == Fixnum)
        @jump_key = where
        execute_instruction_queue (where)
      else
        @jump_key = where
      end
  end

  [:==, :"!=", :>, :<, :<=, :>=].
    zip([:je, :jne, :jg, :jl, :jle, :jge]).
    each do |operation, name|
    define_method(name) do |where|
      where = where
      if execute_instruction (@last_compare).send(operation, 0)
        jmp(where)
      else
        false
      end
    end
  end
end
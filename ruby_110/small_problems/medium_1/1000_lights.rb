=begin

input: an integer n, representing the number of lights
output: an array of integers. the integers represent which light (numbered from 1 to n) remains switched on at the end

explicit rules:
  n represents the number of lights
  n also represents the number of passes/turns
  on the first pass, you go from 1 to n
  on the second pass, you from n to 1, and so on
  on each pass, some lights are switched to the opposite of its previous state
  lights are all initially in the `off` state
  
implicit rules:
  on the first pass, each light which has an ordinal number which is a multiple of 1 is switched
  on the second pass, multiples of 2, and so on
  to determine which states lights are in each time, two arrays are required: on and off
  
  
Examples:
  lights(5) => [1, 4]
  lights(10) => [1, 4, 9 (, [2, 3, 4, 6, 7, 8])
  lights(2) => [1]
  lights (3) => [1]
  lights(4) => [1, 4]
  lights(12) => [1, 4, 9]


DS:
  integer input => `off` == [1..integer]
                    `on` == []
                    
  return `off`
  
Algorithm:
  time = 1
  initialize `off` and `on`
  lights = Array from 1..n
  perform `n` iterations
    each iteration, for each light in lights
      if light % time == 0
        if light is off, 
          turn light on
        else
          turn light off
        end
      else proceed to next light
      
    end
  return `on`
  
=end
require('pry')
require('pry-byebug')

def lights_on(n)
  lights = Array(1..n)
  off = Array(1..n)
  on = []
  
  n.times do |time|
    lights.each do |light|
      if light % (time + 1) == 0
        if off.include?(light)
          off.delete(light)
          on.push(light)
        else
          on.delete(light)
          off.push(light)
        end
      else
        next
      end
    end
  end
  on
end

puts lights_on(950)
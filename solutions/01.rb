class Integer
    def prime?
        return false if self <= 1
        limit = Math.sqrt(self).floor
        2.upto(limit ).none? { |i|  self % i == 0 }
    end

    def harmonic
        (1..self).each.reduce(Rational(0)) do |harm_sum, i|
            harm_sum += Rational(1, i)
        end
    end

    def digits
        abs.to_s.split("").map{|i| i.to_i}
    end

    def prime_factors
        slf = self
        divisors = (2..self.abs).select {|i| self % i == 0 and i.prime?}
        divisors.each do |i| while slf % (i * i) == 0
                slf = slf / i
                divisors.push(i)
            end
        end.sort
    end
end


class Array
    def frequencies
       reduce({}){|hash, i| hash.merge({i => count(i)}) }
    end

    def average
        reduce(0){|sum, i| sum + i}/ length.to_f
    end

    def drop_every(n)
        each_index.select {|i| not ((i+1) % n == 0)}.reduce([])do |arr, i|
            arr.push(self[i])
        end
    end

    def combine_with(other)
        len_difr = -(other.length - self.length).abs
        if self.length < other.length
            then other[0..len_difr-1].zip(self).flatten + other[len_difr..-1]
        elsif self.length == other.length
            self.zip(other).flatten
        else self[0..len_difr -1].zip(other).flatten + self[len_difr..-1]
        end
    end
end
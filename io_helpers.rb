class StringIO
  def read_field_value
    type = read(1)
    case type
    when 't'
      read_boolean
    when 'b'
      read_short_short_int
    when 'B'
      read_short_short_uint
    when 's'
      read_short_int
    when 'u'
      read_short_uint
    when 'I'
      read_long_int
    when 'i'
      read_long_uint
    when 'l'
      read_long_long_int
    when 'f'
      read_float
    when 'd'
      read_double
    when 'D'
      read_decimal
    when 'S'
      read_long_string
    when 'A'
      read_field_array
    when 'T'
      read_timestamp
    when 'F'
      read_field_table
    when 'V'
      nil
    when 'x'
      read_byte_array
    end
  end

  def read_boolean
    read(1).unpack('C')[0] > 0
  end

  def read_short_short_int
    read(1).unpack('c')[0]
  end

  def read_short_short_uint
    read(1).unpack('C')[0]
  end

  def read_short_int
    read(2).unpack('s>')[0]
  end

  def read_short_uint
    read(2).unpack('S>')[0]
  end

  def read_long_int
    read(4).unpack('l>')[0]
  end

  def read_long_uint
    read(4).unpack('L>')[0]
  end

  def read_long_long_int
    read(8).unpack('q>')[0]
  end

  def read_long_long_uint
    read(8).unpack('Q>')[0]
  end

  def read_float
    read(4).unpack('g')[0]
  end

  def read_double
    read(8).unpack('G')[0]
  end

  def read_decimal
    read_short_short_uint
    read_long_int
  end

  def read_short_string
    length = read_short_short_uint
    return read(length).force_encoding('UTF-8')
  end

  def read_long_string
    length = read_long_uint
    return read(length).force_encoding('UTF-8')
  end

  def read_field_array
    array = []
    end_pos = pos + read_long_uint
    while(pos < end_pos)
      array << read_field_value
    end
  end

  def read_timestamp
    read_long_long_uint
  end

  def read_field_table
    table = {}
    end_pos = pos + read_long_uint
    while(pos < end_pos)
      name = read_short_string
      value = read_field_value
      table[name] = value
    end
    table
  end

  def read_byte_array
    length = read_long_uint
    return read(length).force_encoding('BINARY')
  end

    def write_field_value(value)
    case value
    when Boolean
      write 't'
      write_boolean(value)
    when Integer
      if(value < -2147483648 || value > 2147483647)
        write 'l'
        write_long_long_int(value)
      elsif(value < -32768 || value > 32767)
        write 'I'
        write_long_int(value)
      else
        write 's'
        write_short_int(value)
      end
    when Float
      write 'd'
      write_double(value)
    when BigDecimal
      write 'D'
      write_decimal(value)
    when String
      write 'x'
      write_byte_array(value)
    when Array
      write 'A'
      write_field_array(value)
    when Time
      write 'T'
      write_timestamp(value)
    when Hash
      write 'F'
      write_field_table(value)
    when nil
      write 'V'
    end
  end

  def write_boolean(value)
    write (value ? "\1" : "\0")
  end

  def write_short_short_int(value)
    write [value].pack('c')
  end

  def write_short_short_uint(value)
    write [value].pack('C')
  end

  def write_short_int(value)
    write [value].pack('s>')
  end

  def write_short_uint(value)
    write [value].pack('S>')
  end

  def write_long_int(value)
    write [value].pack('l>')
  end

  def write_long_uint(value)
    write [value].pack('L>')
  end

  def write_long_long_int(value)
    write [value].pack('q>')
  end

  def write_long_long_uint(value)
    write [value].pack('Q>')
  end

  def write_float(value)
    write [value].pack('g')
  end

  def write_double(value)
    write [value].pack('G')
  end

  def write_decimal(value)
    write_short_short_uint(0)
    write_long_int(0)
  end

  def write_short_string(value)
    write_short_short_uint(value.bytesize)
    write value
  end

  def write_long_string(value)
    length = write_long_uint(value.bytesize)
    write value
  end

  def write_field_array(value)
    write "\0\0\0\0" # We will have to fill in the length later
    start_pos = pos
    value.each do |v|
      data << write_field_value(v)
    end
    end_pos = pos
    seek(start_pos - 4)
    write = [end_pos - start_pos].pack('N')
    seek(end_pos)
  end

  def write_timestamp(value)
    write_long_long_uint(value)
  end

  def write_field_table(value)
    write "\0\0\0\0" # We will have to fill in the length later
    start_pos = pos
    value.each do |k, v|
      data << write_short_string(k)
      data << write_field_value
    end
    end_pos = pos
    seek(start_pos - 4)
    write = [end_pos - start_pos].pack('N')
    seek(end_pos)
  end

  def write_byte_array(value)
    write_long_string(value)
  end

end

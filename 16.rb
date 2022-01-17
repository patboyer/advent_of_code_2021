#!/usr/bin/ruby -w

class String
	def bits_execute
		version = self[0, 3].to_i(2)
		type    = self[3, 3].to_i(2)

		# literal value
		if type == 4
			idx    = 6
			result = ''

			loop do 
				s = self[idx, 5]
				result += s[1, 4]
				idx += 5
				break if s[0] == '0'
			end

			result = result.to_i(2)
			return { :version => version, :idx => idx, :value => result }
		else 
			# operator packet
			length_type = self[6]
			values      = []

			if length_type == '0'
				sub_packet_length = self[7, 15].to_i(2)
				idx = 22

				loop do 
					break if sub_packet_length <= 0
					result   = self[idx, sub_packet_length].bits_execute 
					version += result[:version]
					idx     += result[:idx] 
					values << result[:value]
					sub_packet_length -= result[:idx]
				end
			else
				num_sub_packets = self[7, 11].to_i(2)
				packet = 1
				idx = 18

				loop do
				  break if packet > num_sub_packets
					result   = self[idx, self.length].bits_execute 
					version += result[:version]
					idx     += result[:idx] 
					values << result[:value]
					packet += 1
				end 
			end

			value = case type
			  when 0 then values.sum
				when 1 then values.inject(1) { |i, prod| i *= prod }
				when 2 then values.min
				when 3 then values.max
				when 5 then (values[0] > values[1])  ? 1 : 0
				when 6 then (values[0] < values[1])  ? 1 : 0
				when 7 then (values[0] == values[1]) ? 1 : 0
			end

			return { :version => version, :idx => idx, :value => value }
		end
	end
end

input =	'420D4900B8F31EFE7BD9DA455401AB80021504A2745E1007A21C1C862801F54AD0765BE833D8B9F4CE8564B9BE6C5CC011E00D5C001098F11A232080391521E4799FC5BB3EE1A8C010A00AE256F4963B33391DEE57DA748F5DCC011D00461A4FDC823C900659387DA00A49F5226A54EC378615002A47B364921C201236803349B856119B34C76BD8FB50B6C266EACE400424883880513B62687F38A13BCBEF127782A600B7002A923D4F959A0C94F740A969D0B4C016D00540010B8B70E226080331961C411950F3004F001579BA884DD45A59B40005D8362011C7198C4D0A4B8F73F3348AE40183CC7C86C017997F9BC6A35C220001BD367D08080287914B984D9A46932699675006A702E4E3BCF9EA5EE32600ACBEADC1CD00466446644A6FBC82F9002B734331D261F08020192459B24937D9664200B427963801A094A41CE529075200D5F4013988529EF82CEFED3699F469C8717E6675466007FE67BE815C9E84E2F300257224B256139A9E73637700B6334C63719E71D689B5F91F7BFF9F6EE33D5D72BE210013BCC01882111E31980391423FC4920042E39C7282E4028480021111E1BC6310066374638B200085C2C8DB05540119D229323700924BE0F3F1B527D89E4DB14AD253BFC30C01391F815002A539BA9C4BADB80152692A012CDCF20F35FDF635A9CCC71F261A080356B00565674FBE4ACE9F7C95EC19080371A009025B59BE05E5B59BE04E69322310020724FD3832401D14B4A34D1FE80233578CD224B9181F4C729E97508C017E005F2569D1D92D894BFE76FAC4C5FDDBA990097B2FBF704B40111006A1FC43898200E419859079C00C7003900B8D1002100A49700340090A40216CC00F1002900688201775400A3002C8040B50035802CC60087CC00E1002A4F35815900903285B401AA880391E61144C0004363445583A200CC2C939D3D1A41C66EC40'
input = input.split(//).collect { |c| c.to_i(16).to_s(2).rjust(4, '0') }.join('')
puts "A: #{input.bits_execute[:version] }"
puts "B: #{input.bits_execute[:value] }"

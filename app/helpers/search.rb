require 'sinatra/base'
require 'bcrypt'

module Search
  def search(query)
    if !query.nil?
			if query.include?('#')
				query = query.scan(/#\w+/).map{|str| str[1..-1]}.join(" ")
				response = Tweet.__elasticsearch__.search(
					query: {
						match: {
						tag_str: query
						}
					}
				).results
			elsif query.include?('@')
				query = query.scan(/@\w+/).map{|str| str[1..-1]}.join(" ")
				response = Tweet.__elasticsearch__.search(
					query: {
						match: {
						mention_str: query,
						}
					}
				).results
			else
				response = Tweet.__elasticsearch__.search(
					query: {
						multi_match: {
						query: query,
						fields: ['tweet^5', 'tag_str', 'mention_str', 'user'],
						fuzziness: "AUTO"
					}
				}
				).results
			end	
			response.to_a.map(&:to_hash)
		end
  end

end
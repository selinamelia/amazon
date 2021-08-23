nokogiri = Nokogiri.HTML(content)

products = nokogiri.css('h2.a-size-mini')
products.each do |product|
    a_element = product.at_css('a.a-link-normal')
    if a_element
        url = URI.join('https://www.amazon.com', a_element['href']).to_s
        if url =~ /\Ahttps?:\/\//i
            pages << {
                url: url,
                page_type: 'products',
                fetch_type: 'browser',
		        force_fetch: true,
                vars: {
                    category: page['vars']['category'],
                    url: url
                }
            }
        end
    end
end

pagination_links = nokogiri.at_css('.a-last > a')
if pagination_links
	next_page = "https://www.amazon.com#{pagination_links['href']}"
	if next_page =~ /\Ahttps?:\/\//i
		pages << {
			url: next_page,
			page_type: 'search',
#			force_fetch: true,
#			method: "GET",
#			headers: {"User-Agent" => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"},
			vars: {
				category: page['vars']['category']
			}
		}
	end
end
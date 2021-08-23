nokogiri = Nokogiri.HTML(content)

products = nokogiri.css('h2.a-size-mini')
products.each do |product|
    a_element = product.at_css('a.a-link-normal')
    if a_element
        url = URI.join('https://www.amazon.com', a_element['href'])
        
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

pagination_links = nokogiri.at_css('ul.a-pagination > a')
if pagination_links
	next_page = "https://www.amazon.com#{pagination_links['href']}"
		pages << {
			url: next_page,
			page_type: 'listings',
			force_fetch: true,
			vars: {
				category: page['vars']['category']
			}
		}
end
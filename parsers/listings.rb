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

current_page = nokogiri.at_css('li.a-selected')
if current_page
	current_page = current_page.text.to_i
elsif !current_page
	current_page = nokogiri.at_css('span.s-pagination-item.s-pagination-selected').text.to_i
end

if current_page < 11
	pagination_links = nokogiri.at_css('.a-last > a')
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
	elsif !pagination_links
		pagination_links = nokogiri.at_css('.s-pagination-item.s-pagination-next.s-pagination-button')
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
	end
end
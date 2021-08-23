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

# pagination_links = nokogiri.css('ul.a-pagination li')
# pagination_links.each do |link|
# 	page_num = link.text.strip
# 	if page_num =~ /[0-9]/
# 		url = "https://www.amazon.com/s?k=LED+%26+LCD+TVs&i=electronics&rh=n%3A6459737011&page=#{page_num}&qid=1629491149&ref=sr_pg_#{page_num}",
# 		pages << {
# 			url: url,
# 			page_type: 'search',
# 			fetch_type: 'browser',
# 			force_fetch: true,
# 			method: "GET",
# 			headers: {"User-Agent" => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"},
# 			driver: {
# 				code: "await page.evaluate('window.scrollBy(0,1200)'); await sleep(1000); await page.evaluate('window.scrollBy(0,1200)'); await sleep(1000);await page.evaluate('window.scrollBy(0,1200)'); await sleep(1000);await page.evaluate('window.scrollBy(0,1200)'); await sleep(1000);"
# 			},
# 			vars: {
# 				category: page['vars']['category']
# 			}
# 		}
# 	end
# end
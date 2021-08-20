nokogiri = Nokogiri.HTML(content)

products = nokogiri.css('h2.a-size-mini a-spacing-none a-color-base s-line-clamp-4')
products.each do |product|
    a_element = product.at_css('a.a-link-normal')
    if a_element
        url = URI.join('https://www.amazon.com/', a_element['href']).to_s
        # url = a_element['href'].gsub(/&qid=[0-9]*/,'')
        if url =~ /\Ahttps?:\/\//i
            pages << {
                url: url,
                page_type: 'products',
                vars: {
                    category: page['vars']['category'],
                    url: url
                }
            }
        end
    end
end
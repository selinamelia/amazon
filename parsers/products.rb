nokogiri = Nokogiri.HTML(content)

# initialize an empty hash
product = {}

#save the url
product['url'] = page['vars']['url']

#save the category
product['category'] = page['vars']['category']

#extract the asin
canonical_link = nokogiri.css('link').find{|link| link['rel'].strip == 'canonical' }
product['asin'] = canonical_link['href'].split("/").last

#extract title
product['title'] = nokogiri.at_css('span.product-title-word-break').text.strip

#extract seller/author
seller_node = nokogiri.at_css('a#bylineInfo')
if seller_node
    product['seller'] = seller_node.text.strip
else
    product['author'] = nokogiri.css('a.contributorNameID').text.strip
end

#extract number of reviews and rating
rating-review = nokogiri.at_css('div.a-fixed-left-grid-col a-col-left')
if rating-review
    product['reviews_count'] = nokogiri.at_css('span.a-size-base a-color-secondary').strip.split(' ').first
    product['rating'] = nokogiri.at_css('a-size-medium a-color-base').text
end

#extract price
price_node = nokogiri.at_css('#price_inside_buybox', '#priceblock_ourprice', '#priceblock_dealprice', '.offer-price')
if price_node
  product['price'] = price_node.text.strip.gsub(/[\$,]/,'').to_f
end

#extract availability
availability_node = nokogiri.at_css('#availability')
if availability_node
  product['available'] = availability_node.text.strip == 'In Stock.' ? true : false
else
  product['available'] = nil
end

#extract product description
description = ''
nokogiri.css('#feature-bullets li').each do |li|
  unless li['id'] || (li['class'] && li['class'] != 'showHiddenFeatureBullets')
    description += li.text.strip + ' '
  end
end
product['description'] = description.strip

# specify the collection where this record will be stored
product['_collection'] = "products"

# save the product to the job’s outputs
outputs << product
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

#extract number of reviews
reviews_node = nokogiri.at_css('span#acrCustomerReviewText')
reviews_count = reviews_node ? reviews_node.text.strip.split(' ').first.gsub(',','') : nil
product['reviews_count'] = reviews_count =~ /^[0-9]*$/ ? reviews_count.to_i : 0

#extract rating
rating_node = nokogiri.at_css('#averageCustomerReviews span.a-icon-alt')
stars_num = rating_node ? rating_node.text.strip.split(' ').first : nil
product['rating'] = stars_num =~ /^[0-9.]*$/ ? stars_num.to_f : nil

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
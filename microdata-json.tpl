{* Structured Data Json - LD Microdata for Prestashop 1.6.X
*
* Add this code in your smarty global.tpl/header.tpl file to show Organization, WebPage, Website and Product Microdata in ld+json format.
* Requires Prestashop 'productcomments' module for review stars ratings.
* by Ruben Divall @rubendivall http://www.rubendivall.com 
*}
<script type="application/ld+json">
{ 
	"@context" : "http://schema.org",
	"@type" : "Organization",
	"name" : "{$shop_name|escape:'html':'UTF-8'}",
	"url" : "{$link->getPageLink('index', null, null, null, false, null, true)|escape:'html':'UTF-8'}",
	"logo"  : {
		"@type":  "ImageObject",
		"url":  "{$logo_url}"
 }
}
</script>
<script type="application/ld+json">
{
	"@context":"http://schema.org",
	"@type":"WebPage",
	"isPartOf": {
		"@type":"WebSite",
		"url":  "{$link->getPageLink('index', null, null, null, false, null, true)|escape:'html':'UTF-8'}",
		"name": "{$shop_name|escape:'html':'UTF-8'}"
    },
	"name": "{$meta_title}",
	"url":  "{$base_dir}{trim($smarty.server.REQUEST_URI,'/')}"
}
</script>
{if $page_name =='index'}
<script type="application/ld+json">
{
	"@context": "http://schema.org",
	"@type":  "WebSite",
	"url":  "{$link->getPageLink('index', null, null, null, false, null, true)|escape:'html':'UTF-8'}",
	"image" : {
	"@type":  "ImageObject",
	"url":  "{$logo_url}"
	},
	"potentialAction": {
		"@type": "SearchAction",
		"target": "{$link->getPageLink('search', null, null, null, false, null, true)|escape:'html':'UTF-8'}?search_query={literal}{search_term}{/literal}",
		"query-input": "required name=search_term"
	}
}
</script>
{/if}

{if $page_name == 'product'}
<script type="application/ld+json">
	{	
	"@context": "http://schema.org/",
	"@type": "Product",
	"name": "{$product->name}",
	"image": "{$link->getImageLink($product->link_rewrite, $cover.id_image, 'home_default')|escape:'html':'UTF-8'}",
	"description": "{$product->description_short|strip_tags|escape:'html':'UTF-8'}",
	{if $product->reference}"mpn": "{$product->reference|escape:'html':'UTF-8'}",{/if}
	{if $product->ean13}"gtin13": "{$product->ean13|escape:'html':'UTF-8'}",{/if}
	{if $product_manufacturer->name}"brand": {
		"@type": "Thing",
		"name": "{$product_manufacturer->name|escape:'html':'UTF-8'}"
	},{/if}
	{if $nbComments && $ratings.avg}"aggregateRating": {
	   	"@type": "AggregateRating",
		"ratingValue": "{$ratings.avg|round:1|escape:'html':'UTF-8'}",
		"reviewCount": "{$nbComments|escape:'html':'UTF-8'}"
	},{/if}
	"offers": {
		"@type": "Offer",
		"priceCurrency": "{$currency->iso_code}", 
		"price": "{$product->getPrice(true, $smarty.const.NULL, 2)|round:"2"}",
		{if $product->condition == 'new'}"itemCondition": "http://schema.org/NewCondition",{/if}{if $product->condition == 'used'}"itemCondition": "http://schema.org/UsedCondition",{/if}{if $product->condition == 'refurbished'}"itemCondition": "http://schema.org/RefurbishedCondition",{/if}
		{if $product->quantity > 0}"availability": "http://schema.org/InStock",{/if}
		"seller": {
			"@type": "Organization",
			"name": "{$shop_name|escape:'html':'UTF-8'}"
			}
	}
} 
</script>
{/if}
{** End of Structured Data Json - LD Microdata for Prestashop 1.6.X }

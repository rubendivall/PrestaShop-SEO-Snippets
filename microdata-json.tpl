{* Structured Data Json - LD Microdata for Prestashop 1.6.X & 1.7
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
    "url" : "{$link->getPageLink('index', true)|escape:'html':'UTF-8'}",
    "logo" : {
        "@type":"ImageObject",
        "url":"{$logo_url|escape:'html':'UTF-8'}"
    }
}
</script>
<script type="application/ld+json">
{
    "@context":"http://schema.org",
    "@type":"WebPage",
    "isPartOf": {
        "@type":"WebSite",
        "url":  "{$link->getPageLink('index', true)|escape:'html':'UTF-8'}",
        "name": "{$shop_name|escape:'html':'UTF-8'}"
    },
    "name": "{$meta_title|escape:'html':'UTF-8'}",
    "url":  "{if isset($force_ssl) && $force_ssl}{$base_dir_ssl|escape:'html':'UTF-8'}{trim($smarty.server.REQUEST_URI,'/')|escape:'html':'UTF-8'}{else}{$base_dir|escape:'html':'UTF-8'}{trim($smarty.server.REQUEST_URI,'/')|escape:'html':'UTF-8'}{/if}"
}
</script>
{if $page_name =='index'}
<script	type="application/ld+json">
{
	"@context":	"http://schema.org",
	"@type": "WebSite",
	"url": "{$link->getPageLink('index', true)|escape:'html':'UTF-8'}",
	"image": {
	"@type": "ImageObject",
	"url":  "{$logo_url|escape:'html':'UTF-8'}"
	},
    "potentialAction": {
    "@type": "SearchAction",
    "target": "{'--search_term_string--'|str_replace:'{search_term_string}':$link->getPageLink('search',true,null,['search_query'=>'--search_term_string--'])}",
     "query-input": "required name=search_term_string"
	 }
}
</script>
{/if}
{if $page_name == 'product'}
<script type="application/ld+json">
    {
    "@context": "http://schema.org/",
    "@type": "Product",
    "name": "{$product->name|escape:'html':'UTF-8'}",
    "description": "{$product->description_short|strip_tags|escape:'html':'UTF-8'}",
	{if $product->reference}"mpn": "{$product->id|escape:'html':'UTF-8'}",{/if}
    {if $product_manufacturer->name}"brand": {
        "@type": "Thing",
        "name": "{$product_manufacturer->name|escape:'html':'UTF-8'}"
    },{/if}
    {if isset($nbComments) && $nbComments && $ratings.avg}"aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "{$ratings.avg|round:1|escape:'html':'UTF-8'}",
        "reviewCount": "{$nbComments|escape:'html':'UTF-8'}"
    },{/if}
    {if empty($combinations)}
    "offers": {
        "@type": "Offer",
        "priceCurrency": "{$currency->iso_code|escape:'html':'UTF-8'}",
        "name": "{$product->name|escape:'html':'UTF-8'}",
        "price": "{$product->getPrice(true, $smarty.const.NULL, 2)|round:'2'|escape:'html':'UTF-8'}",
        "image": "{$link->getImageLink($product->link_rewrite, $cover.id_image, 'home_default')|escape:'html':'UTF-8'}",
        {if $product->ean13}
        "gtin13": "{$product->ean13|escape:'html':'UTF-8'}",
        {else if $product->upc}
        "gtin13": "0{$product->upc|escape:'html':'UTF-8'}",
        {/if}
        "sku": "{$product->reference}",
        {if $product->condition == 'new'}"itemCondition": "http://schema.org/NewCondition",{/if}
        {if $product->condition == 'used'}"itemCondition": "http://schema.org/UsedCondition",{/if}
        {if $product->condition == 'refurbished'}"itemCondition": "http://schema.org/RefurbishedCondition",{/if}
        "availability":{if $product->quantity > 0} "http://schema.org/InStock"{else} "http://schema.org/OutOfStock"{/if},
        "seller": {
            "@type": "Organization",
            "name": "{$shop_name|escape:'html':'UTF-8'}"
        }
    }
    {else}
    "offers": [
      {foreach key=atomik item=combination from=$combinations}
        {
        "@type": "Offer",
        "name": "{$product->name|escape:'html':'UTF-8'} - {$combination.reference}",
        "priceCurrency": "{$currency->iso_code|escape:'html':'UTF-8'}",
        "price": "{$combination.finalprice|round:'2'}",
        "image": "{if $combination.id_image > 0}{$link->getImageLink($product->link_rewrite, $combination.id_image, 'home_default')|escape:'html':'UTF-8'}{else}{$link->getImageLink($product->link_rewrite, $cover.id_image, 'home_default')|escape:'html':'UTF-8'}{/if}",
        {if $combination.ean13}
        "gtin13": "{$combination.ean13|escape:'html':'UTF-8'}",
        {else if $combination.upc}
        "gtin13": "0{$combination.upc|escape:'html':'UTF-8'}",
        {/if}
        "sku": "{$combination.reference}",
        {if $combination.condition == 'new'}"itemCondition": "http://schema.org/NewCondition",{/if}
        {if $combination.condition == 'used'}"itemCondition": "http://schema.org/UsedCondition",{/if}
        {if $combination.condition == 'refurbished'}"itemCondition": "http://schema.org/RefurbishedCondition",{/if}
        "availability": {if $combination.quantity > 0}"http://schema.org/InStock"{else}"http://schema.org/OutOfStock"{/if},
        "seller": {
            "@type": "Organization",
            "name": "{$shop_name|escape:'html':'UTF-8'}"}
        } {if !$combination@last},{/if}          
     {/foreach}
    ]
    {/if}
}
</script>
{/if}
{** End of Structured Data Json - LD Microdata for Prestashop 1.6.X **}

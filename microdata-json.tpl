{* Structured Data Json - LD Microdata for Prestashop 1.6.X & 1.7
*
* Add this code in your smarty global.tpl/header.tpl file to show Organization, WebPage, Website and Product Microdata in ld+json format.
* Requires Prestashop 'productcomments' module for review stars ratings.
* by Ruben Divall @rubendivall http://www.rubendivall.com 
* Module by @atomiksoft: https://addons.prestashop.com/en/seo-natural-search-engine-optimization/24511-microformats-in-ldjson.html
*}
<script type="application/ld+json">
{
    "@context" : "http://schema.org",
    "@type" : "Organization",
    "name" : "{$atomik.shop_name|escape:'html':'UTF-8'}",
    "url" : "{$atomik.link_index|escape:'html':'UTF-8'}",
    {if isset($atomik.social_urls) && count($atomik.social_urls > 0)}"sameAs" : [
    {foreach item=social_profile from=$atomik.social_urls}
    {if !empty($social_profile)}
        "{$social_profile|escape:'htmlall':'UTF-8'}"{if !$social_profile@last},{/if}
    {/if}
    {/foreach}
    ],{/if}

    "logo" : {
        "@type":"ImageObject",
        "url":"{$atomik.logo_url|escape:'html':'UTF-8'}"
    }
}
</script>
<script type="application/ld+json">
{
    "@context":"http://schema.org",
    "@type":"WebPage",
    "isPartOf": {
        "@type":"WebSite",
        "url":  "{$atomik.link_index|escape:'html':'UTF-8'}",
        "name": "{$atomik.shop_name|escape:'html':'UTF-8'}"
    },
    "name": "{$atomik.meta_title|escape:'html':'UTF-8'}",
    "url":  "{if isset($force_ssl) && $force_ssl}https://{else}http://{/if}{$smarty.server.HTTP_HOST|escape:'htmlall':'UTF-8'}{$smarty.server.REQUEST_URI|escape:'htmlall':'UTF-8'}"
}
</script>
{if $atomik.page_name =='index'}
<script	type="application/ld+json">
{
	"@context":	"http://schema.org",
	"@type": "WebSite",
	"url": "{$atomik.link_index|escape:'html':'UTF-8'}",
	"image": {
	"@type": "ImageObject",
	"url":  "{$atomik.logo_url|escape:'html':'UTF-8'}"
	},
    "potentialAction": {
    "@type": "SearchAction",
    "target": "{'--search_term_string--'|str_replace:'{search_term_string}':$atomik.link_search|escape:'htmlall':'UTF-8'}",
     "query-input": "required name=search_term_string"
	 }
}
</script>
{/if}
{if $atomik.page_name == 'product'}
<script type="application/ld+json">
    {
    "@context": "http://schema.org/",
    "@type": "Product",
    "name": "{$atomik.product.name|escape:'html':'UTF-8'}",
    "description": "{$atomik.product.description_short|strip_tags|escape:'html':'UTF-8'}",
	{if $atomik.product.ean13}
        "gtin13": "{$atomik.product.ean13|escape:'html':'UTF-8'}",
    {else if $atomik.product.upc}
        "gtin13": "0{$atomik.product.upc|escape:'html':'UTF-8'}",
    {/if}
    {if $atomik.product.reference}"mpn": "{$atomik.product.id|escape:'html':'UTF-8'}",{/if}
    {if $atomik.product_manufacturer.name}"brand": {
        "@type": "Thing",
        "name": "{$atomik.product_manufacturer.name|escape:'html':'UTF-8'}"
    },{/if}
    {if isset($nbComments) && $nbComments && $ratings.avg}"aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "{$ratings.avg|round:1|escape:'html':'UTF-8'}",
        "reviewCount": "{$nbComments|escape:'html':'UTF-8'}"
    },{/if}
    {if empty($combinations)}
    "offers": {
        "@type": "Offer",
        "priceCurrency": "{$atomik.currency.iso_code|escape:'html':'UTF-8'}",
        "name": "{$atomik.product.name|escape:'html':'UTF-8'}",
        "price": "{$atomik.product.price|round:'2'|escape:'html':'UTF-8'}",
        "image": "{$atomik.product.cover_link|escape:'html':'UTF-8'}",

        "sku": "{$atomik.product.reference|escape:'htmlall':'UTF-8'}",
        {if $atomik.product.condition == 'new'}"itemCondition": "http://schema.org/NewCondition",{/if}
        {if $atomik.product.condition == 'used'}"itemCondition": "http://schema.org/UsedCondition",{/if}
        {if $atomik.product.condition == 'refurbished'}"itemCondition": "http://schema.org/RefurbishedCondition",{/if}
        "availability":{if $atomik.product.quantity > 0} "http://schema.org/InStock"{else} "http://schema.org/OutOfStock"{/if},
        "seller": {
            "@type": "Organization",
            "name": "{$atomik.shop_name|escape:'html':'UTF-8'}"
        }
    }
    {else}
    "offers": [
      {foreach item=combination from=$combinations}
        {
        "@type": "Offer",
        "name": "{$atomik.product.name|escape:'html':'UTF-8'} - {' '|implode:$combination.attributes_values} {$combination.reference|escape:'htmlall':'UTF-8'} ",
        "priceCurrency": "{$atomik.currency.iso_code|escape:'html':'UTF-8'}",
        "price": "{$atomik.product.price|round:'2'|escape:'html':'UTF-8'}",
        "image": "{if $combination.id_image > 0}{$link->getImageLink($atomik.product.link_rewrite, $combination.id_image, 'home_default')|escape:'html':'UTF-8'}{else}{$atomik.product.cover_link|escape:'html':'UTF-8'}{/if}",

        "sku": "{$combination.reference|escape:'htmlall':'UTF-8'}",
        {if $atomik.product.condition == 'new'}"itemCondition": "http://schema.org/NewCondition",{/if}
        {if $atomik.product.condition == 'used'}"itemCondition": "http://schema.org/UsedCondition",{/if}
        {if $atomik.product.condition == 'refurbished'}"itemCondition": "http://schema.org/RefurbishedCondition",{/if}
        "availability": {if $combination.quantity > 0}"http://schema.org/InStock"{else}"http://schema.org/OutOfStock"{/if},
        "seller": {
            "@type": "Organization",
            "name": "{$atomik.shop_name|escape:'html':'UTF-8'}"}
        } {if !$combination@last},{/if}
     {/foreach}
    ]
    {/if}
    {if isset($comments)}
    , "review": [
        {foreach from=$comments item=comment}
        {if $comment.content}
            {
              "@type": "Review",
              "author": "{$comment.customer_name|escape:'html':'UTF-8'}",
              "datePublished": "{$comment.date_add|escape:'html':'UTF-8'|substr:0:10}",
              "description": "{$comment.content|escape:'html':'UTF-8'|nl2br}",
              "name": "{$comment.title|escape:'html':'UTF-8'}",
              "reviewRating": {
                "@type": "Rating",
                "bestRating": "5",
                "ratingValue": "{$comment.grade|escape:'html':'UTF-8'}",
                "worstRating": "0"
              }
            } {if !$comment@last},{/if}
        {/if}
        {/foreach}
    ]
    {/if}
}
</script>
{/if}
{if $atomik.stores|count > 0}
{foreach item=atomik_store from=$atomik.stores}
{if $atomik_store.active = 1}
<script type="application/ld+json">
    {
        "@context": "http://schema.org",
        "@type": "Store",
        "name":"{$atomik_store.name|escape:'htmlall':'UTF-8'}",
        "url": "{$atomik.link_index|escape:'html':'UTF-8'}",
        "address": {
            "@type": "PostalAddress",
            "addressLocality": "{$atomik_store.city|escape:'htmlall':'UTF-8'}",
            "postalCode": "{$atomik_store.postcode|escape:'htmlall':'UTF-8'}",
            "streetAddress": "{$atomik_store.address1|escape:'htmlall':'UTF-8'} {$atomik_store.address2|escape:'htmlall':'UTF-8'}"
        },
        "image": {
            "@type": "ImageObject",
            "url":  "{$atomik.img_ps_dir|escape:'htmlall':'UTF-8'}st/{$atomik_store.id_store|escape:'htmlall':'UTF-8'}.jpg"
        },
        "geo": {
            "@type": "GeoCoordinates",
            "latitude": "{$atomik_store.latitude|escape:'htmlall':'UTF-8'}",
            "longitude": "{$atomik_store.longitude|escape:'htmlall':'UTF-8'}"
        },
        "priceRange": "{$atomik.price_range.min|escape:'htmlall':'UTF-8'} - {$atomik.price_range.max|escape:'htmlall':'UTF-8'}",
        "openingHoursSpecification": [
            { "@type": "OpeningHoursSpecification","dayOfWeek": "http://schema.org/Monday","opens": "{$atomik_store.hours.0.opens|escape:'htmlall':'UTF-8'}","closes": "{$atomik_store.hours.0.closes|escape:'htmlall':'UTF-8'}" },
            { "@type": "OpeningHoursSpecification","dayOfWeek": "http://schema.org/Tuesday","opens": "{$atomik_store.hours.1.opens|escape:'htmlall':'UTF-8'}","closes": "{$atomik_store.hours.1.closes|escape:'htmlall':'UTF-8'}" },
            { "@type": "OpeningHoursSpecification","dayOfWeek": "http://schema.org/Wednesday","opens": "{$atomik_store.hours.2.opens|escape:'htmlall':'UTF-8'}","closes": "{$atomik_store.hours.2.closes|escape:'htmlall':'UTF-8'}" },
            { "@type": "OpeningHoursSpecification","dayOfWeek": "http://schema.org/Thursday","opens": "{$atomik_store.hours.3.opens|escape:'htmlall':'UTF-8'}","closes": "{$atomik_store.hours.3.closes|escape:'htmlall':'UTF-8'}" },
            { "@type": "OpeningHoursSpecification","dayOfWeek": "http://schema.org/Friday","opens": "{$atomik_store.hours.4.opens|escape:'htmlall':'UTF-8'}","closes": "{$atomik_store.hours.4.closes|escape:'htmlall':'UTF-8'}" },
            { "@type": "OpeningHoursSpecification","dayOfWeek": "http://schema.org/Saturday","opens": "{$atomik_store.hours.5.opens|escape:'htmlall':'UTF-8'}","closes": "{$atomik_store.hours.5.closes|escape:'htmlall':'UTF-8'}" },
            { "@type": "OpeningHoursSpecification","dayOfWeek": "http://schema.org/Sunday","opens": "{$atomik_store.hours.6.opens|escape:'htmlall':'UTF-8'}","closes": "{$atomik_store.hours.6.closes|escape:'htmlall':'UTF-8'}" }
        ],
        "telephone": "{$atomik_store.phone|escape:'htmlall':'UTF-8'}"
    }
</script>
{/if}
{/foreach}
{/if}
{** End of Structured Data Json - LD Microdata for Prestashop 1.6.X **}

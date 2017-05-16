{{#site.posts}}
<h3><a href="/{{{url}}}">{{{title}}}</a></h3>
<time>{{date}}</time>
{{#categoryDisplay}}
        &middot; <a href="/categories/{{{url}}}">{{category}}</a>
{{/categoryDisplay}}
{{/site.posts}}

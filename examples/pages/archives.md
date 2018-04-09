{{#posts}}
<h3><a href="/{{{url}}}">{{{title}}}</a></h3>
<time>{{date}}</time>
<category>
{{#categoryDisplay}}
&middot; <a href="/categories/{{{url}}}">{{category}}</a>
{{/categoryDisplay}}
</category>
{{/posts}}

---
title: Search
---

<input type="search" id="search-input" data-info-init="Initializing..."
  data-text-length=500 data-limit=100 data-delay=300>

<div class="search-results">
<section>
<h2><a target="_blank"></a></h2>
<div class="search-preview"></div>
</section>
</div>

<script src="https://cdn.jsdelivr.net/npm/fuse.js@6.6.2" defer></script>
<script src="/js/fuse-search.js" defer></script>
<script>
    // const options = {
    //     getFn: (obj, path) => {
    //         // Use the default `get` function
    //         const value = Fuse.config.getFn(obj, path)
    //         // ... do something with `value`
    //         return value
    //     }
    // }
</script>


<style type="text/css">
#search-input {
  width: 100%;
  font-size: 1.2em;
  padding: .5em;
}
.search-results b {
  background-color: yellow;
}
.search-preview {
  margin-left: 2em;
}
</style>

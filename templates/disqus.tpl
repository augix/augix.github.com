<html>
<head>
	<link rel="Stylesheet" type="text/css" href="%root_path%templates/skinny_disqus.css" />
	<title>%title%</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body>
<a name='top'></a>
<div class="container">
    <div class="header">
		<h1>%title%</h1> 
	</div><!-- end of header -->
	<div class="post"><!-- start of post -->
	%content%
	</div><!-- end of post -->
	<div class="backhome">
		<a href="%root_path%index.html">Main Page</a><br>
        <a href="#disqus_thread" data-disqus-identifier="%title%">First article</a>
        <a href="#comment" id="disqus_thread-show" class="showLink" onclick="showHide('disqus_thread');return true;">Comment(s)</a>
	</div>
<br>

<!-- javascript to hide comments -->
<script language="javascript" type="text/javascript">
/*** JavaScript: Show/Hide Content ***/
function showHide(shID) {
   if (document.getElementById(shID)) {
      if (document.getElementById(shID+'-show').style.display != 'none') {
         document.getElementById(shID+'-show').style.display = 'none';
         document.getElementById(shID).style.display = 'block';
      }
      else {
         document.getElementById(shID+'-show').style.display = 'inline';
         document.getElementById(shID).style.display = 'none';
      }
   }
}
</script>

<!-- javascript to show count of comments -->
<script type="text/javascript">
    /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
    var disqus_shortname = 'evo-devo'; // required: replace example with your forum shortname

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function () {
        var s = document.createElement('script'); s.async = true;
        s.type = 'text/javascript';
        s.src = 'http://' + disqus_shortname + '.disqus.com/count.js';
        (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
    }());
</script>


<a name="comment"></a>
<div id="disqus_thread" class="comment"><p align='right'><a href="#top" id="disqus_thread-hide" class="hideLink" onclick="showHide('disqus_thread');return true;">Hide comments</a></p>
</div>

<script type="text/javascript">
    /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
    var disqus_shortname = 'evo-devo'; // required: replace example with your forum shortname

    // The following are highly recommended additional parameters. Remove the slashes in front to use.
    // var disqus_identifier = 'unique_dynamic_id_1234';
    var disqus_identifier = "%title%";
    // var disqus_url = 'http://example.com/permalink-to-page.html';

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>

</div><!-- end of container -->

</body>
</html>

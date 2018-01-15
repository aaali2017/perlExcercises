#!/usr/bin/perl
    use LWP::UserAgent;
    use HTTP::Request::Common qw(GET);
    use HTTP::Cookies;
    use CGI;

    my $ua = LWP::UserAgent->new;

    # Define user agent type
    $ua->agent('Mozilla/20.0');

    # Cookies
    $ua->cookie_jar(
        HTTP::Cookies->new(
            file => 'cookies.txt',
            autosave => 1
        )
    );

     my $cgi = new CGI;
     my $website  = $cgi->param( 'website' );

     my $out  = $cgi->header(
         -type    => 'text/html',
         -charset => 'utf-8',
     );

     $out .= $cgi->start_form(
         -method  => "post",
         -action  => "/students/cpjs/getpage.pl",
     );

     $out .= $cgi->h1("Browse to site:");

     $out .= $cgi->p(
         "URL: ",
         $cgi->textfield( -name => 'website' ),
         $cgi->submit,
     );
       
    if ($website) {

        if (index($website, "http://") == -1) {
	    $website = "http://" . $website;
	}

        my $req = GET $website ;
        my $res = $ua->request($req);

        if ($res->is_success) {

            my $q = new CGI;
            print $q->header();
            my $output = $res->content;
            my $replaceString = '<base href="' . $website . '/">';
            $output =~ s/(<head.*>)/$1 $replaceString/i ;

            print $output;
        } 
	else {
            print $res->status_line . "\n";
        }
    	} 
	else {
 	       print $out;
    	}

    exit 0;
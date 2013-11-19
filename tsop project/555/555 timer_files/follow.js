$(document).ready(function(){

	var errorMsg = {
		'length':'Please enter a longer comment, a minimum of 30 characters.',
		'repeatlines':'Your comment plays like a broken record. Please update your comment.',
		'repeatletters':'What is "#offense#"? Please update your comment, thanks!',
		'sparsevowels':'What is "#offense#"? Please update your comment, thanks!',
		'wordrepeat':'Woah, too much repetition, please be more detailed',
		'manysymbols':'That\'s a lot of symbols. Please update your comment, thanks!',
		'repeatsymbols':'What is "#offense#"? Please update your comment, thanks!',
		'repeatnumbers':'What is "#offense#"? Please update your comment, thanks!',
		'linebreaks':'That is a lot of lines for that much content.',
		'manylinks':'You\'re posting too many links.',
    'wordlengthtoolong': 'What is "#offense#"? Please update your comment, thanks!',
    'urllengthtoolong': 'Very sorry but we do not allow urls longer than 100 characters.'
	};
	
	// Settings box 
	$('#settingsIcon').click(function(){
		$('#settingsBox').toggle();
	})

  $('#fbOff').click(function(){
    userSettings.openLinksInVotingFrame = false;
    cookies.saveSettings();
  });

  $('#fbOn').click(function(){
    userSettings.openLinksInVotingFrame = true;
    cookies.saveSettings();
  });

  $('#logo').click(function(){
    window.location.href = '/search/web/' + param_query;
  });  

  $('#closeScourFrame').click(function(){
    window.top.location = param_link;
  });

	// Handle Frame sizing
	var isExpanded = 0;
	var canSubmit = 0;
	var commentSubmitted = 0;
	$('#framed').height($(window).height()-38+"px"); 
  setFrameSize(0);
	$(window).resize(function(){
		setFrameSize(isExpanded);
	})
	
	// Restore textarea to it's default text
	$('#comment').val($('#comment').get(0).defaultValue);
	
	$(document.body).scroll(function(){
		document.body.scrollTop = 0;		
	})
	
	function setFrameSize(expand){
		if(expand) {
			isExpanded = 1;
			$('#logo').animate({'width':'23px'},600);
			$('#framed').css({'height': $(window).height()-168+"px"},600);
//			$('#followBarHelp').hide('fast');
//			$('#relevancyVote').hide('fast');
			$('#comment').css({'height':'125px','width':'475px'},600);
			$('#commentBox').css({'width':'495px'},600);
      $('#characterCounter').show();
			$('#contractBar').show();
//			$('#copyFlashIcon').hide();
		} else {
			isExpanded = 0;
			$('#logo').animate({'width':'97px'},600);
			$('#framed').css({'height': $(window).height()-38+"px"},600);
//			$('#followBarHelp').show('fast');
//			$('#relevancyVote').show('fast');
			$('#comment').css({'height':'18px','width':'200px'},600);
			$('#commentBox').css({'width':'220px'},600)
			$('#characterCounter').hide();
			$('#contractBar').hide();
			$('#commentError').hide();
//			$('#copyFlashIcon').show();
		}
	}


	$(window).blur(function(e){
    if (isExpanded == 1)
    {
      setFrameSize(0);  
    }    
  })

	// Focus/Blur Comment
	$('#comment').focus(function(e){
		if(commentSubmitted) {
			$(this).blur();
			return;
		}
		setFrameSize(1);
		if($('#comment').val() == $('#comment').get(0).defaultValue) {
			$('#comment').val('');			
		}
		$('#comment').addClass('active');
	})
	
	$('#contractBar').click(function(e){
		e.preventDefault();
		setFrameSize(0);
		if($('#comment').val() == "") {
			$('#comment').val($('#comment').get(0).defaultValue);
			$('#comment').removeClass('active');
		}
	})
	
  $('#relevancyVoteUp').click(function(e){
    e.preventDefault();
    if (!userSettings.isLoggedIn())
    {
      if (window.confirm("You must be logged in to vote.  Would you like to login now?"))
      {
        window.top.location.href = "/login/";
      }
      return false;
    }
    $(this).blur();
    $.ajax({
      url: '/services/addPosVote/',
      data: {
        'query': param_query,
        'url' : param_link
      },
      type: 'post',
      cache: false,
      dataType: 'json',
      success: function (data) {
        $('#relevancyVoteUp').hide();
        $('#relevancyVoteDown').hide();
        $('#relevancyVoteText').html('Thank-you for furthering the Scour community.');
      }
    });  

  });

  $('#relevancyVoteDown').click(function(e){
    e.preventDefault();
    if (!userSettings.isLoggedIn())
    {
      if (window.confirm("You must be logged in to vote.  Would you like to login now?"))
      {
        window.top.location.href = "/login/";
      }
      return false;
    }

    $(this).blur();
    $.ajax({
      url: '/services/addNegVote/',
      data: {
        'query': param_query,
        'url' : param_link
      },
      type: 'post',
      cache: false,
      dataType: 'json',
      success: function (data) {
        $('#relevancyVoteUp').hide();
        $('#relevancyVoteDown').hide();
        $('#relevancyVoteText').html('Thank-you for furthering the Scour community.');
      }
    });  
  });

	$('#voteButtonsUp').click(function(e){
		e.preventDefault();
		$(this).blur();
		if(canSubmit==1) {
			postComment('up', $(this));
		}
	})
	
	$('#voteButtonsDown').click(function(e){
		e.preventDefault();
		$(this).blur();
		if(canSubmit==1) {
			postComment('down', $(this));
		}
	})
	
	// Copy ---
	$('#copyFlashIcon').click(function(e){
		e.preventDefault();
		$(this).blur();
		var str = param_link;
		if(window.copyFlash)
			window.document["copyFlash"].copy(str);
		if(document.copyFlash)
			document.copyFlash.copy(str);
			
		$('#copyFlashMsg').show();
		setTimeout(function(){
			$('#copyFlashMsg').hide();
		},2000);
	});
	
	function triggerError(errorKey, offense) {
		canSubmit = 0;
		if(offense!=undefined) {
			var err = errorMsg[errorKey].replace(/#offense#/g,offense);
		} else {
			var err = errorMsg[errorKey];
		}
		$('#commentErrorText').text(err);
		$('#commentError').show();
		$('#voteButtonsUp').addClass('disable');
		$('#voteButtonsDown').addClass('disable');
	}
	
	function clearError() {
		canSubmit = 1;
		$('#commentErrorText').text('');
		$('#commentError').hide();
		$('#voteButtonsUp').removeClass('disable');
		$('#voteButtonsDown').removeClass('disable');
	}
	
	function postComment(vote, button){
    var comment = $('#comment').val();
		var commentLength = comment.replace(/ /g, '').length;
		// Comment length between 30-500
		if(commentLength < 30 || commentLength > 500) {
			triggerError('length');
			return;
		}
	
		button.addClass('loading');
	
	
		canSubmit = 0;
		$('#voteButtonsUp').addClass('disable');
		$('#voteButtonsDown').addClass('disable');

    // submit the comment
    if (userSettings.isLoggedIn())
    {
      $.ajax({
        url: '/services/addComment/',
        data: {
          'query': param_query,
          'comment': comment,
          'url': param_link,
          'positive': vote == "up"
        },
        type: 'post',
        cache: false,
        dataType: 'json',
        success: function (result) {
          commentSubmitted = 1;
          $('#comment').val('Thanks for commenting!');
          button.removeClass('loading');
          $('#voteButtons').hide();
          setFrameSize(0);
        }
      });
    }
    else
    {
      if (window.confirm("You must be logged in to comment.  Would you like to login now?"))
      {
        window.top.location.href = "/login/";
      }
      return;
    }    
	}
	
	// Comment Validation
	$('#comment').keyup(function(){
			var comment = $(this).val();
			var commentLines = comment.split('\n').length;
			var commentLength = comment.replace(/ /g, '').length;
			// Extract URLs
			var commentUrls = comment.match(/http[^ ]+/gi);
			// Remove URLs from data we'll be testing
			comment = comment.replace(/http[^ ]+/gi,' ');
			var commentWords = comment.split(' ');
      for(var i=0; i<commentWords.length; i++)
        commentWords[i] = commentWords[i].toString();
			
			// Comment length between 30-500
			if(commentLength < 30 || commentLength > 500) {
				$('#characterCount').removeClass('good');
			} else {
				$('#characterCount').addClass('good');
			}

      // check url lengths
      for(var x in commentUrls)
      {
        if (commentUrls[x].length > 100)
        {
          triggerError('urllengthtoolong',commentUrls[x]);
          return;
        }
      }

      // check word lengths
      for (var x in commentWords)
      {
        if (commentWords[x].length > 35)
        {
          triggerError('wordlengthtoolong',commentWords[x]);
          return;
        }
      }
			
			// Update Comment Length Counter
			$('#characterCount').text(commentLength);
			
			// Repetitive Characters - 4 in a row
			var repetitiveChars = comment.match(/([^ ])\1\1\1/g);
			if(repetitiveChars) {
				for(var x in commentWords) {
					if(commentWords[x].toString().indexOf(repetitiveChars[0])>=0) {
						var letOffense = commentWords[x];
						if(letOffense != undefined) {
							break;
						}
					}
				}
				if(letOffense!=undefined) {
					triggerError('repeatletters',letOffense);
					return;
				}
			}
			
			// Repetitive Numbers - Including spaces
			var repetitiveNumbers = comment.replace(/ /g,'').match(/[0-9 ]{6,}/g);
			if(repetitiveNumbers) {
				var numOffense = repetitiveNumbers[0];
				triggerError('repeatnumbers',numOffense);
				return;
			}
			
			// Repetitive Words
			// Remove all spaces and then check
			if(comment.replace(/ /g,'').match(/([a-z]{2,})\1\1/gi)) {
				triggerError('wordrepeat');
				return;
			}
			
			// Repeating Consonants
			var repeatConsonants = comment.match(/([qwrtplkjhgfdszxcvbnm]{5,})/gi);
			if(repeatConsonants) {
				for(var x in commentWords) {
					if(commentWords[x].toString().indexOf(repeatConsonants[0])>=0) {
						var vowelOffense = commentWords[x];
						break;
					}
				}
				triggerError('sparsevowels',vowelOffense);
				return;
			}
			
			// More than 10 non-punctuation symbols
			if(comment.replace(/[a-z0-9 \.\,\?\!\(\)\;\:\/]/gi,'').length>10) {
				triggerError('manysymbols');
				return;
			}
			
			// 4+ Repeating Symbols 
			var repeatingSymbols = comment.replace(/ /g,'').match(/([^a-z0-9\/\.\,\?\!\(\)\;\:\\\n/]{15,})/i);
			if(repeatingSymbols) {
				var symbolOffense = repeatingSymbols[0];
				triggerError('repeatsymbols',symbolOffense);
				return;
			}
			
			// More than 3 links
			if(commentUrls) {
				if(commentUrls.length>3) {
					triggerError('manylinks');
					return;
				}
			}
			
			// Too many line breaks
			// Must average 20 characters per line
			if(commentLines > 3 && commentLength/commentLines<20) {
				triggerError('linebreaks',numOffense);
				return;
			}
			
			// Repetitive Lines
			var repeatLines = comment.match(/^(.*)\n\1\n\1/gm);
			if(repeatLines) {
				triggerError('repeatlines');
				return;
			}
			
			clearError();
		});	
})
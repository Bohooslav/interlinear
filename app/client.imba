import allverses from './verses.json'
# import allverses from './test_verses.json'
import books from './books.json'


import './styles'

let agent = window.navigator.userAgent;
let isWebkit = (agent.indexOf("AppleWebKit") > 0);
let isIOS = (agent.indexOf("iPhone") > 0 || agent.indexOf("iPod") > 0)
let isAndroid = (agent.indexOf("Android")  > 0)
let isNewBlackBerry = (agent.indexOf("AppleWebKit") > 0 && agent.indexOf("BlackBerry") > 0)
let isWebOS = (agent.indexOf("webOS") > 0);
let isWindowsMobile = (agent.indexOf("IEMobile") > 0)
let isSmallScreen = (screen.width < 767 || (isAndroid && screen.width < 1000))
let isUnknownMobile = (isWebkit && isSmallScreen)
let isMobile = (isIOS || isAndroid || isNewBlackBerry || isWebOS || isWindowsMobile || isUnknownMobile)
let MOBILE_PLATFORM = no

if isMobile && isSmallScreen && document.cookie.indexOf( "mobileFullSiteClicked=") < 0
	MOBILE_PLATFORM = yes

let show_chapters_of = 1
let bible_menu_left = -300

const settings = {
	get book
		return #book || 0

	set book newval
		#book = newval
		window.localStorage.setItem('book', newval)

	get chapter
		return #chapter || 0

	set chapter newval
		#chapter = newval
		window.localStorage.setItem('chapter', newval)

	bookname: '',
	direction: 'rtl',
}

tag word
	prop word

	def strongLink
		`https://bohuslav.me/Dictionary/?strong={word.strongs}`

	<self title=word.parsing id=word.sort>
		<a href=strongLink() target='_blank'> word.strongs
		<span[c:warm4]> word.translit
		<span[fs:1.5em fw:bolder]> word.word
		<span[c:warm4]> word.BSB
		# <span[fs:14px]> word.parsing
		# <span[fs:14px]> word.footnote

	css
		d:inline-flex
		fld:column
	
	css
		a
			c:blue4
			td:none
			fs:0.8em


tag app
	words = []
	verses = []

	def setup
		settings.book = parseInt(window.localStorage.getItem('book')) || 1
		settings.chapter = parseInt(window.localStorage.getItem('chapter')) || 1

		getText settings.book, settings.chapter

	def showChapters bookid
		if show_chapters_of == bookid
			show_chapters_of = 0
		else
			show_chapters_of = bookid

	def nameOfBook bookid
		for book in books
			if book.bookid == bookid
				return book.name
		return bookid.toUpperCase!

	def getText bookid, chapter
		words = allverses.filter(do(v) return v.book == bookid && v.chapter == chapter).sort(do(a, b) return a.sort - b.sort)
		verses = []
		if words[0]?.strongs.startsWith('H')
			settings.direction = 'rtl'
		else
			settings.direction = 'ltr'

		for word in words
			if word.verse != verses[verses.length - 1]?.[0]?.verse
				verses.push([word])
			else
				verses[-1].push(word)

		settings.bookname = nameOfBook(bookid)
		settings.chapter = chapter
		settings.book = bookid

		# log verses
		# log words

	def mousemove e
		if not MOBILE_PLATFORM
			if e.x < 32
				bible_menu_left = 0
			elif 300 < e.x < window.innerWidth - 300
				bible_menu_left = -300

	def chaptersOfCurrentBook
		for book in books
			if book.bookid == settings.book
				return book.chapters

	def nextChapter
		if settings.chapter + 1 <= chaptersOfCurrentBook()
			getText(settings.book, settings.chapter + 1)
		else
			let current_index = books.indexOf(books.find(do |element| return element.bookid == settings.book))
			if books[current_index + 1]
				getText(books[current_index + 1].bookid, 1)

	def prevChapter
		if settings.chapter - 1 > 0
			getText(settings.book, settings.chapter - 1)
		else
			let current_index = books.indexOf(books.find(do |element| return element.bookid == settings.book))
			if books[current_index - 1]
				getText(books[current_index - 1].bookid, books[current_index - 1].chapters)



	<self @mousemove=mousemove>
		<nav[l:{bible_menu_left}px]>
			<p[p:16px 8px fw:bold]> "Berean Study Bible"
			for book in books
				<div key=book.bookid>
					<button.book_in_list dir="auto" .selected=(book.bookid == settings.book) @click=showChapters(book.bookid)> book.name
					if book.bookid == show_chapters_of
						<ul[o@off:0 m:0 0 16px @off:-24px 0 24px transition-timing-function:quad h@off:0px of:hidden] dir="auto" ease>
							for i in [0 ... book.chapters]
								<li.chapter_number .selected=(i + 1 == settings.chapter && book.bookid==settings.book) @click=getText(book.bookid, i+1)> i+1

		<main>
			<header[d:flex jc:space-between ai:center]>
				<button.arrow @click=prevChapter [d@lt-md:none]>
					<svg[transform: rotate(90deg)] width="16" height="10" viewBox="0 0 8 5">
						<title> 'Previous'
						<polygon points="4,3 1,0 0,1 4,5 8,1 7,0">
				<h1> settings.bookname, ' ', settings.chapter
				<button.arrow @click=nextChapter [d@lt-md:none]>
					<svg[transform: rotate(-90deg)] width="16" height="10" viewBox="0 0 8 5">
						<title> 'Next'
						<polygon points="4,3 1,0 0,1 4,5 8,1 7,0">

			<article[direction:{settings.direction}]>
				for verse in verses
					<span[fw:bold c:rose4]> verse[0].verse
					for word in verse
						<word word=word>

		<footer[ta:center mt:auto max-width:1024px m:auto]>
			<p[fs:12px p:16px 0 o:0.7 us:none]> "The Holy Bible, Berean Study Bible, Copyright ©2016, 2020 by Bible Hub. All Rights Reserved Worldwide. Free Licensing for use in Websites, Apps, Software, and Audio: {<a [c:rose0] href='http://berean.bible/licensing.htm'> 'http://berean.bible/licensing.htm'}"


	css
		min-height:100vh
		d:flex
		fld:column
	
	css
		nav
			d:flex
			fld:column
			padding:8px
			pb:256px
			bgc:$bgc
			pos: fixed
			t:0 b:0
			w:300px
			ofy:auto
			bdr:1px solid $acc-bgc
			zi:10
			us:none

			.book_in_list
				w:100%
				ta:left
				font:inherit
				padding: 10px;
				color:inherit @hover:rose4
				text-decoration:none
				bgc:transparent
				border:none
				cursor:pointer
				rd:4px

			ul
				p:0
			
			.chapter_number
				cursor: pointer
				display: inline-block
				text-align: center
				color: inherit @hover:rose4
				height: 54px
				width: 20%
				font-size: 20px
				padding-top: 16px

		header
			text-align:center
		
		main
			p:0 16px 128px
			m:auto
			max-width:1024px
		
		main
			h1
				ta:center
				p:8vh 0

			article
				d:flex
				flw:wrap
				rg:32px
				cg:16px
			
			.arrow
				display: flex
				justify-content: center
				align-items: center
				height: 64px
				width: 64px
				fill: $c
				bgc:transparent @hover:$acc-bgc-hover
				cursor: pointer
				border-radius@hover: 50%
				fill@hover: amber4
				transform@hover: rotate(360deg)
				bd:none

imba.mount <app>

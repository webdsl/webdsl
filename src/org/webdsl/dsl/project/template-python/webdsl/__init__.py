import utils
import db
import querylist
import markdown
import re
import session

RE_LINKS = re.compile(r'(\[\[(\w+)(\(([^\)]*)\))?(\|([^\]]+))?\]\])')

def parse_wikitext(str):
    links = RE_LINKS.findall(str)
    for (whole, page, dummy, arg, dummy2, title) in links:
        url = ''
        if page == 'home':
            page = ''
        if arg:
            url = '/%s/%s' % (page, arg)
        else:
            url = '/%s' % page
        if not title:
            title = page
        str = str.replace(whole, '[%s](%s)' % (title, url))
    return markdown.Markdown(safe_mode='escape').convert(str)

def parse_text(str):
    return markdown.Markdown(safe_mode='escape').convert(str)

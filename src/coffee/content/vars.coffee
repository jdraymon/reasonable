QUICKLOAD_MAX_ITEMS = 20

# Get domain name from URL
URL_REGEX = /^https?:\/\/(www\.)?([^\/]+)?/i

# Picture regex is based on RFC 2396. It doesn't require a prefix and allows ? and # suffixes.
PICTURE_REGEX = /(?:([^:\/?#]+):)?(?:\/\/([^\/?#]*))?([^?#]*\.(?:jpe?g|gif|png|bmp))(?:\?([^#]*))?(?:#(.*))?/i

# Pretty strict filter. May want to revise for linking to someone's profile page.
YOUTUBE_REGEX = /^(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9-_]+)(?:\#t\=[0-9]{2}m[0-9]{2}s)?/i

# Article URL regular expressions
ARTICLE_REGEX = /reason\.com\/(.*?)(?:\#comment)?s?(?:\_[0-9]{6,7})?$/
ARTICLE_SHORTEN_REGEX = /^(?:archives|blog)?\/(?:19|20)[0-9]{2}\/(?:0[1-9]|1[0-2])\/(?:0[1-9]|[12][0-9]|3[0-1])\/(.*?)(?:\#|$)/

# Post labels
COLLAPSE = "show direct"
UNCOLLAPSE = "show all"
IGNORE = "ignore"
UNIGNORE = "unignore"

# Date finder
DATE_INDEX = 2 # index of node in commentheader containing date
COMMENT_DATE_REGEX = ///
                        (1[0-2]|[1-9])            # Month
                     \. (3[0-1]|[1-2][0-9]|[1-9]) # Day
                     \. ([0-9]{2})                # Year
                     \s@\s
                        (1[0-2]|[1-9])            # Hour
                     \: ([0-5][0-9])              # Minute
                        ([AP]M)                   # AM/PM
                     ///
ACTIVITY_CUTOFFS = [
  300000  # 5 minutes
  900000  # 15 minutes
  1800000 # 30 minutes
  3600000 # 1 hour
  7200000 # 2 hours
]
LATEST_COMMENT_COUNT = 5

# White Indian
WHITE_INDIAN = ///
               city-stat(?:e|ist|ism)  # agriculture is great
               |
               gambol                  # you are not free to gambol
               |
               fibertar(?:d|ian)       # fiber is good for you
               ///i
WHITE_INDIAN_HEAP_BIG_YELL = ///
                             STATE  # shh
                             ///

# Avatars
AVATAR_PREFIX = "http://www.gravatar.com/avatar/"
AVATAR_SUFFIX = "?s=40&d=identicon"
MY_MD5 = "b5ce5f2f748ceefff8b6a5531d865a27"

# Lights out
LIGHTS_OUT_OPACITY = 0.5
MINIMAL_OPACITY = 0.01
TOTAL_OPACITY = 1
FADE_SPEED = 500
MINIMAL_FADE_SPEED = 5

# Others and magic number avoidance
COMMENT_HISTORY = "Comment History"
ESCAPE_KEY = 27
FIRST_MATCH = 1
QUICKLOAD_SPEED = 100
UPDATE_POST_TIMEOUT_LENGTH = 60000

months = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"]

settings = {}
trolls   = []
lightsOn = false

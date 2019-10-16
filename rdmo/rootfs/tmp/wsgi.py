import os
import re

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

try:
    os.environ['BASE_URL']
except KeyError:
    pass
else:
    if bool(re.search('[a-z0-9]', os.environ['BASE_URL'])) is False:
        os.environ['BASE_URL'] = ''

application = get_wsgi_application()

import django_filters

from core import models


class Asset(django_filters.FilterSet):

    class Meta:
        model = models.Asset
        exclude = ['file']


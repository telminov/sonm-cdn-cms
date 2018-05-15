import django_filters

from core import models


class Asset(django_filters.FilterSet):

    class Meta:
        model = models.Asset
        fields = {
            'dd': ['gte', ],
            'uuid': ['exact', ],
            'name': ['icontains', ],
            'description': ['icontains', ]
        }


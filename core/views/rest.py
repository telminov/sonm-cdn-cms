import datetime

from rest_framework import viewsets

from core import models
from core import serializers


class AssetViewSet(viewsets.ModelViewSet):
    queryset = models.Asset.objects.all()
    serializer_class = serializers.AssetSerializer

    def get_queryset(self):
        date = self.request.GET.get('date')

        if date:
            try:
                format_date = datetime.datetime.strptime(date, '%Y-%m-%d')
                self.queryset = models.Asset.objects.filter(dm__date=format_date)
            except ValueError:
                raise Exception('Not a date')

        return self.queryset

from rest_framework import viewsets

from core import models, serializers, filters


class AssetViewSet(viewsets.ModelViewSet):
    queryset = models.Asset.objects.all()
    serializer_class = serializers.AssetSerializer
    filter_class = filters.Asset

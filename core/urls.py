from django.urls import path, include
from rest_framework.routers import DefaultRouter

from core.views.views import DownloadAsset
from core.views.rest import AssetViewSet

router = DefaultRouter()

router.register(r'assets', AssetViewSet)

urlpatterns = [
    path('asset/<uuid>/', DownloadAsset.as_view(), name='download_asset'),
    path('rest/', include(router.urls))
]
from django.urls import path, include
from django.views.generic import RedirectView
from rest_framework.routers import DefaultRouter

from core.views.views import DownloadAsset
from core.views.rest import AssetViewSet

router = DefaultRouter()

router.register(r'assets', AssetViewSet)

urlpatterns = [
    path('', RedirectView.as_view(url='admin', permanent=False)),
    path('asset/<uuid>/', DownloadAsset.as_view(), name='download_asset'),
    path('rest/', include(router.urls))
]
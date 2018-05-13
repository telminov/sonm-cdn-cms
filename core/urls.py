from django.urls import path

from core.views import DownloadAsset

urlpatterns = [
    path('asset/<uuid>/', DownloadAsset.as_view(), name='download_asset'),
]
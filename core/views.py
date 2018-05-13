import mimetypes
import os

from django.conf import settings
from django.http import Http404
from django.http import HttpResponse
from django.shortcuts import get_object_or_404
from django.views import View

from core.models import Asset


class DownloadAsset(View):
    model = Asset

    def get(self, request, *args, **kwargs):
        try:
            asset = get_object_or_404(self.model, uuid=self.kwargs['uuid'])
        except self.model.DoesNotExist:
            raise self.model("No Asset matches the given query.")

        asset_file_path = settings.MEDIA_ROOT + str(asset.file)

        if os.path.exists(asset_file_path):
            with open(asset_file_path, 'rb') as file:
                file_name = os.path.basename(asset_file_path)
                mime_type_guess = mimetypes.guess_type(file_name)
                response = HttpResponse(file, content_type=mime_type_guess[0])
                response['Content-Disposition'] = 'attachment; filename=' + file_name
                return response

        return Http404("{path} does not exist.".format(path=asset_file_path))


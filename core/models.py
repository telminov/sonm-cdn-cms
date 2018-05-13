from django.db import models

import uuid


class ExcludeDeletedManager(models.Manager):
    def get_queryset(self):
        return super(ExcludeDeletedManager, self).get_queryset().exclude(dd__isnull=False)


class Asset(models.Model):
    uuid = models.UUIDField('uuid', default=uuid.uuid4, unique=True, editable=False)
    name = models.CharField(max_length=100)
    description = models.TextField(max_length=240)
    file = models.FileField(upload_to='assets/', null=True, blank=True)
    dc = models.DateTimeField(auto_now_add=True)
    dm = models.DateTimeField(auto_now=True)
    dd = models.DateTimeField(null=True, editable=False)

    objects = ExcludeDeletedManager()
    standard_objects = models.Manager()

    def __str__(self):
        return self.name
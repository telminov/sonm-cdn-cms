from django.db import models

import uuid


class ExcludeDeletedManager(models.Manager):
    def get_queryset(self):
        return super(ExcludeDeletedManager, self).get_queryset().exclude(dd__isnull=False)


class Asset(models.Model):
    uuid = models.UUIDField(default=uuid.uuid4, unique=True, editable=False, verbose_name='uuid')
    name = models.CharField(max_length=100, verbose_name='Имя файла')
    description = models.TextField(max_length=240, verbose_name='Описание')
    file = models.FileField(upload_to='files/', null=True, blank=True, verbose_name='Файл')
    dc = models.DateTimeField(auto_now_add=True, verbose_name='Дата создания')
    dm = models.DateTimeField(auto_now=True, verbose_name='Последнее изменение')
    dd = models.DateTimeField(null=True, verbose_name=u'Дата удаления')

    objects = ExcludeDeletedManager()
    standard_objects = models.Manager()

    class Meta:
        verbose_name = 'Ресурс'
        verbose_name_plural = 'Ресурсы'

    def __str__(self):
        return self.name
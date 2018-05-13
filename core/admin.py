from django.contrib import admin

from core.models import Asset


class AssetAdmin(admin.ModelAdmin):
    list_display = ('uuid', 'name', 'description', 'file')
    list_filter = ('dc', 'dm', 'dd')
    search_fields = ('uuid', 'name', 'description')


admin.site.register(Asset, AssetAdmin)
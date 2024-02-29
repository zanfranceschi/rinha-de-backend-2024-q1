from django.db import models
from django.core.exceptions import ValidationError


class StrictIntegerField(models.fields.IntegerField):
    def to_python(self, value):
        if value is None:
            return value
        if not isinstance(value, int):
            raise ValidationError(
                self.error_messages["invalid"],
                code="invalid",
                params={"value": value},
            )
        try:
            return int(value)
        except (TypeError, ValueError):
            raise ValidationError(
                self.error_messages["invalid"],
                code="invalid",
                params={"value": value},
            )

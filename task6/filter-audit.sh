#!/bin/bash
# filter-audit.sh – извлекает подозрительные события из audit.log и сохраняет в audit-extract.json

if [ ! -f "audit.log" ]; then
    echo "Файл audit.log не найден."
    exit 1
fi

# Используем jq для фильтрации
jq -s '
  [
    .[] |
    select(
      (.objectRef.resource == "secrets" and .verb == "get") or
      (.verb == "create" and .objectRef.subresource == "exec") or
      (.objectRef.resource == "pods" and .requestObject.spec.containers[].securityContext.privileged == true) or
      (.objectRef.resource == "rolebindings" and .verb == "create") or
      (.objectRef.resource == "configmaps" and .objectRef.name == "audit-policy") or
      (.verb == "delete" and .objectRef.resource == "configmaps" and .objectRef.name == "audit-policy")
    )
  ] | unique_by(.auditID)
' audit.log > audit-extract.json

echo "Подозрительные события сохранены в audit-extract.json"
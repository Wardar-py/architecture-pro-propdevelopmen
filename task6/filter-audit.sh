#!/bin/bash

if [ ! -f "audit.log" ]; then
    echo "Файл audit.log не найден."
    exit 1
fi

jq -s '
  [
    .[] |
    select(
      # попытка доступа к secrets (list/get)
      (.objectRef.resource == "secrets" and (.verb == "list" or .verb == "get")) or
      # exec в под (глагол get)
      (.objectRef.subresource == "exec" and .verb == "get") or
      # создание привилегированного пода (по имени, без requestObject)
      (.objectRef.resource == "pods" and .objectRef.name == "privileged-pod") or
      # создание/изменение rolebinding с эскалацией
      (.objectRef.resource == "rolebindings" and .verb == "create" and .objectRef.name == "escalate-binding") or
      # доступ к configmap audit-policy (если будет)
      (.objectRef.resource == "configmaps" and .objectRef.name == "audit-policy")
    )
  ] | unique_by(.auditID)
' audit.log > audit-extract.json

echo "Подозрительные события сохранены в audit-extract.json"
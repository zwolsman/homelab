{{- range $i, $vol := .Node.Data.diskVolumes }}
apiVersion: v1alpha1
kind: UserVolumeConfig
name: {{ $vol.name }}
provisioning:
  diskSelector:
    match: disk.wwid == "{{ $vol.wwid }}"
  minSize: 0
  grow: true
---
{{- end }}

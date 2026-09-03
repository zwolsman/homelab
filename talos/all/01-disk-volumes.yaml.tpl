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
machine:
  kubelet:
    extraMounts:
      {{- range $vol := .Node.Data.diskVolumes }}
      - destination: /var/mnt/{{ $vol.name }}
        type: bind
        source: /var/mnt/{{ $vol.name }}
        options:
          - bind
          - rshared
          - rw
      {{- end }}
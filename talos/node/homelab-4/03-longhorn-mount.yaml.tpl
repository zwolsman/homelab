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
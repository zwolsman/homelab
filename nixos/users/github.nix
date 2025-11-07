{
  users.users."github" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCVmJpGqv1y8fy2Rq7lY5nxReygTmtzUN5VdtUTt4gA0aUdJ/Ky/fDPV68iDgJ0S8Zaa7POfR1sVuGAZivqFfKXxhMGo7VR0Y2EJWJEKa/jUi8GRYSp8AnyvaS/NE9y0WJqBZ4m10/I9M2ksdQTraEXr29OrOyRDIpKOa8jfcNmhSFznVCkI+X6/F/2ynBin+PP2XsuAwid1uAbrBw80rHRJylgBnCq0knlaj42WpkNmOCzr5iPt0Bea9lbXxXYymX2CL/3bsVQcBRHWCLqX1sEzbCAzXIHxhXJyNZeDV8u0jbGlS73qPknV2eXmmOsaceGEGOrMmr1wu6NxmPM3q58/nAARv9yfb+2Hk8kGZcpfYAHJthP1n8MLxI8rZDsgBzmTLWdoaTUWTFNtV8a6GueJQe6xOnkArcYeg4h5k1PNPQhABUaD4DPbXOjvd0CAUwN8ZDCWB6zvM1GDikbm2fF31VEISYurymWoPPctcnvnDTyRAWj8Ru0z59Bao5W2slWFr2+ziaYeinRfST+BAy8kMALc3FqQVvM/C67eksgW/tiPUUO6R4zGS9hGgJ8mTU7axIjyaHHJNqP17XHiOXuG0DrJ262Iot0eRJ0Ss6XJMVnbAXOy/GZpmbfdsTi8bZRrPCjH4iz4Fohoi2RDqJwCySkmG9HIZhmFN0ZwZwydw== github"
    ];
  };

  security.sudo = {
    extraRules = [
      {
        users = [ "github" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}

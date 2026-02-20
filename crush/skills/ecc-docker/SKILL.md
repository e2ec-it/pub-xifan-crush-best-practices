# ECC Docker Patterns

Compose checklist:
- Named volumes for persistent data
- Explicit networks; avoid "host" unless necessary
- Healthchecks for key services
- Resource limits where possible
- Avoid baking secrets into images; use env / secret mounts

If debugging:
- Check container logs
- Verify ports and DNS on the compose network
- Validate volume permissions

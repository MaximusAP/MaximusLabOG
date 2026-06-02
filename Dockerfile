FROM nginx:latest

# Remove default config and assets
RUN rm -rf /usr/share/nginx/html/* \
    && rm /etc/nginx/conf.d/default.conf

# Copy site assets
COPY index.html    /usr/share/nginx/html/
COPY hero.jpeg     /usr/share/nginx/html/
COPY pipeline.jpeg /usr/share/nginx/html/

# Copy nginx config
COPY nginx.conf  /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]

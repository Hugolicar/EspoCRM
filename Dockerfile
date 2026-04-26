FROM espocrm/espocrm:latest

# Copia os arquivos da imagem para um diretório temporário
RUN cp -r /var/www/html /var/www/html_backup

# Script que garante os arquivos na inicialização
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

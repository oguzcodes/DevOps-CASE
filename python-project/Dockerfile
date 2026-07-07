# python-project/Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Güvenlik: root olmayan özel bir kullanıcı oluştur (Kurumsal Best-Practice) test
RUN addgroup --system etlgroup && adduser --system --group etluser

RUN pip install requests   

# ETL betiğini kopyala
COPY ETL.py .

# Dosya sahipliğini yeni kullanıcıya ver
RUN chown -R etluser:etlgroup /app

# root olmayan kullanıcıya geçiş yap
USER etluser

# Konteyner ayağa kalktığında çalışacak komut
CMD ["python", "ETL.py"]
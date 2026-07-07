# python-project/Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Güvenlik: root olmayan özel bir kullanıcı oluştur (Kurumsal Best-Practice)
RUN addgroup --system etlgroup && adduser --system --group etluser

# Eğer projede dış kütüphaneler varsa (pandas, requests vb.) requirements.txt kopyalanır
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# ETL betiğini kopyala
COPY ETL.py .

# Dosya sahipliğini yeni kullanıcıya ver
RUN chown -R etluser:etlgroup /app

# root olmayan kullanıcıya geçiş yap
USER etluser

# Konteyner ayağa kalktığında çalışacak komut
CMD ["python", "ETL.py"]
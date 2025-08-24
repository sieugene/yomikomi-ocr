FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Create cache directory with write permissions
RUN mkdir -p /app/.paddleocr && chmod -R 777 /app/.paddleocr

# Copy requirements
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ .

# Switch to non-root user for security (Hugging Face Spaces requirement)
RUN useradd -m -u 1000 user && chown -R user:user /app
USER user

# Expose Hugging Face Spaces default port
EXPOSE 7860

# Command to run FastAPI
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]
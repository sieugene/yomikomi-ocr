from paddleocr import PaddleOCR
import os

def ocr_image(image_path):
    # Set a writable cache directory for PaddleOCR models
    cache_dir = "/app/.paddleocr"
    os.makedirs(cache_dir, exist_ok=True)  # Create directory if it doesn't exist
    use_gpu = os.getenv("USE_GPU", "false").lower() == "true"
    # Initialize PaddleOCR with Japanese language support and custom cache directory
    ocr = PaddleOCR(use_angle_cls=True, lang="japan", use_gpu=use_gpu, user_cache_dir=cache_dir)
    result = ocr.ocr(image_path, cls=True)
    extracted_text = []
    for idx in range(len(result)):
        res = result[idx]
        for line in res:
            extracted_text.append(line[1][0])
    return "\n".join(extracted_text)
"""Minimal smoke test for the *generated* article (requires pdftotext)."""
import re
import subprocess
import sys
from pathlib import Path

pdf = Path(sys.argv[1] if len(sys.argv) > 1 else 'build/article.pdf')
assert pdf.is_file() and pdf.stat().st_size > 1000, f'PDF not found: {pdf}'
text = subprocess.check_output(
    ['pdftotext', '-enc', 'UTF-8', str(pdf), '-'],
    encoding='utf-8'
)
normalized = re.sub(r'\s+', ' ', text).casefold()
for required in (
    'содержание', 'архитектура системы',
    'рисунок 1', 'таблица 1', 'хранение данных в системе',
    'приложение',
):
    if required not in normalized:
        raise SystemExit(f'ERROR: expected text is absent from generated PDF: {required}')
if '??' in text:
    raise SystemExit('ERROR: unresolved LaTeX references (??) found in PDF')
print(f'OK: {pdf} exists, numbered captions, contents and appendix found.')

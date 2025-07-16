# Copyright (c) Opendatalab. All rights reserved.

import os
import json
from loguru import logger


if __name__ == '__main__':
    # os.system('pip uninstall -y mineru')
    # os.system('pip install -U git+https://gitee.com/myhloli/MinerU.git@dev')
    # os.system('pip uninstall -y flash-attn')
    # os.system('pip install flash-attn --no-build-isolation')
    # os.system('mineru-models-download -s modelscope -m vlm')
    # os.system('pip install -U gradio-pdf')
    try:
        with open('/root/mineru.json', 'r+') as file:
            config = json.load(file)
            
            delimiters = {
                'display': {'left': '\\[', 'right': '\\]'},
                'inline': {'left': '\\(', 'right': '\\)'}
            }
            
            config['latex-delimiter-config'] = delimiters
            
            if os.getenv('apikey'):
                config['llm-aided-config']['title_aided']['api_key'] = os.getenv('apikey')
                config['llm-aided-config']['title_aided']['enable'] = True
            
            file.seek(0)  # 将文件指针移回文件开始位置
            file.truncate()  # 截断文件，清除原有内容
            json.dump(config, file, indent=4)  # 写入新内容
    except Exception as e:
        logger.exception(e)
    os.system('mineru-gradio --enable-sglang-engine true --enable-api false --max-convert-pages 20 --latex-delimiters-type b --mem-fraction-static 0.7 --enable-torch-compile --server-name 0.0.0.0 --server-port 7860')

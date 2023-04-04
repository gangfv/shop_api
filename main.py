import os
from typing import List
import aiofiles as aiofiles
from fastapi import FastAPI, UploadFile

app = FastAPI()


@app.post("/")
async def post_endpoint(files: List[UploadFile], user: str = None):
    try:
        os.mkdir(user)
    except:
        return {"message": "Данный пользователь сущесвует"}
    for file in files:
        async with aiofiles.open(f"{user}/{file.filename}", 'wb') as out_file:
            content = await file.read()
            await out_file.write(content)
    return {"message": "OK"}

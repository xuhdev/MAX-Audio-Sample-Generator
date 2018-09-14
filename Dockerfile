FROM codait/max-base

# Fill in these with a link to the bucket containing the model and the model file name
ARG model_bucket=http://max-assets.s3-api.us-geo.objectstorage.softlayer.net/max-audio-sample-generator
ARG model_files=models.tar.gz

# Get model archive and unzip it to assets folder
RUN wget -nv ${model_bucket}/${model_files} --output-document=/workspace/assets/${model_files} --show-progress --progress=bar:force:noscroll
RUN tar -x -C assets/ -f assets/${model_files} -v

# Install dependencies for wave file encoding
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Python package versions
ARG tf_version=1.5.0

RUN pip install tensorflow==${tf_version} && \
    pip install librosa && \
    pip install numpy 

COPY . /workspace

EXPOSE 5000

CMD python app.py
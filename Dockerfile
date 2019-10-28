FROM ubuntu as intermediate

# install git
RUN apt-get update
RUN apt-get install -y git

# add credentials on build
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa

# make sure your domain is accepted
# RUN touch /root/.ssh/known_hosts
# RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts


RUN echo "Cloning repo: key::004 " && \
        git --exec-path && \
        git clone https://github.com/tpublic/mkiii.git && \
        mv mkiii microkube && \
        find microkube/*



FROM docker.bluelight.limited:5000/bluelightltd/microkube-bundler-image:latest

RUN mkdir -p /home/app/microkube

# copy the repository form the previous image
COPY --from=intermediate /microkube /home/app/microkube

RUN chown -R app.app /home

USER app


RUN echo "Checking repo" && \
        cd /home/app/microkube && \
        find ./*



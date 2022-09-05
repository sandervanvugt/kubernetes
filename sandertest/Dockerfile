FROM alpine
MAINTAINER Sander <mail@sandervanvugt.nl>

# Add a file
ADD ./sander.repo /etc/yum.repos.d/

# Install cool software
RUN apk add procps

CMD ["ps", "aux"] 

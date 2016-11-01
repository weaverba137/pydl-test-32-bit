FROM ioft/i386-ubuntu:trusty
MAINTAINER Benjamin Alan Weaver <baweaver@lbl.gov>
#
# Tools needed
#
RUN apt-get -y install git # graphviz texlive-latex-extra dvipng
#
# Add the travis user with sudo.
#
RUN adduser --disabled-password --gecos "" travis
RUN chown travis:travis /home/travis
#
# Install miniconda file.
#
COPY Miniconda-latest-Linux-x86.sh /home/travis
RUN chmod a+x /home/travis/Miniconda-latest-Linux-x86.sh
#
# Set user.
#
USER travis
WORKDIR /home/travis
#
# Conda setup.
#
RUN linux32 -- /bin/bash Miniconda-latest-Linux-x86.sh -b -p ${HOME}/miniconda
ENV PATH=/home/travis/miniconda/bin:${PATH}
RUN conda config --set always_yes yes --set changeps1 no
# RUN conda create -q -n test python=2.7
# RUN source activeate test
RUN conda install -q pytest pip astropy scipy
#
# Clone.
#
RUN git clone --depth=50 --branch=fix-32-bit https://github.com/weaverba137/pydl.git weaverba137/pydl
WORKDIR /home/travis/weaverba137/pydl
RUN git submodule update --init --recursive
#
# Run test.
#
ENTRYPOINT ["linux32", "--"]
CMD ["python", "setup.py", "test", "-v", "-V"]

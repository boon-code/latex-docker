FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN     apt-get update \
     && apt-get install -y \
                texlive \
                texlive \
                texlive-base \
                texlive-bibtex-extra \
                texlive-binaries \
                texlive-extra-utils \
                texlive-font-utils \
                texlive-fonts-extra-doc \
                texlive-fonts-recommended \
                texlive-fonts-recommended-doc \
                texlive-generic-recommended \
                texlive-humanities-doc \
                texlive-lang-german \
                texlive-latex-base \
                texlive-latex-base-doc \
                texlive-latex-extra \
                texlive-latex-extra-doc \
                texlive-latex-recommended \
                texlive-latex-recommended-doc \
                texlive-luatex \
                texlive-math-extra \
                texlive-metapost-doc \
                texlive-pictures \
                texlive-pictures-doc \
                texlive-pstricks \
                texlive-pstricks-doc \
                texlive-publishers-doc \
                texlive-science-doc \
                texlive-fonts-extra \
                texlive-formats-extra \
                texlive-full \
                texlive-games \
                texlive-generic-extra \
                texlive-humanities \
                texlive-lang-all \
                texlive-latex3 \
                texlive-metapost \
                texlive-music \
                texlive-omega \
                texlive-plain-extra \
                texlive-publishers \
                texlive-science \
                texlive-xetex \
                latexmk \
                make \
                umlet \
     && rm -rf /var/lib/apt/lists/*

# Prepare, compile and install su-exec
COPY su-exec/su-exec.c su-exec/Makefile /tmp/compile-su-exec/
RUN     apt-get update \
     && apt-get install -y gcc \
     && cd /tmp/compile-su-exec \
     && make \
     && install -m 0755 su-exec /usr/bin/ \
     && cd / \
     && apt-get purge -y gcc \
     && rm -rf /var/lib/apt/lists/* \
     && rm -r /tmp/compile-su-exec

ENV NAME=
ENV USER="builder"
ENV UID=1000
ENV GID=1000
ENV DEBUG="0"

# Add scripts & configs
COPY    build.sh /

# Allow access for all users
RUN     chmod a+rx /build.sh \
     && mkdir /source \
     && chmod a+rwx /source \
     && mkdir /images \
     && chmod a+rwx /images \
     && mkdir /build \
     && chmod a+rwx /build \
     && mkdir /result \
     && chmod a+rwx /result

CMD ["/build.sh"]

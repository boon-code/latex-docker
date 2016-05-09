FROM ubuntu:14.04

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
                texlive-doc-de \
                texlive-doc-en \
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
     && rm -rf /var/lib/apt/lists/*

ENV NAME=
ENV USER="builder"
ENV DEBUG="0"

# Add scripts & configs
COPY    build.sh /

# Allow access for all users
RUN     chmod a+rx /build.sh \
     && mkdir /source \
     && chmod a+rwx /source \
     && mkdir /build \
     && chmod a+rwx /build \
     && mkdir /result \
     && chmod a+rwx /result

CMD ["/build.sh"]

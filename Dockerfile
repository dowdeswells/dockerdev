
FROM haskell:7.10.3
MAINTAINER Simon Dowdeswell


ENV ATOM_VERSION v1.10.2

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    git \
                    curl \
                    ca-certificates \
                    libgtk2.0-0 \
                    libxtst6 \
                    libnss3 \
                    libgconf-2-4 \
                    libasound2 \
                    fakeroot \
                    gconf2 \
                    gconf-service \
                    libcap2 \
                    libnotify4 \
                    libxtst6 \
                    libnss3 \
                    gvfs-bin \
                    xdg-utils \
                    python && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L https://github.com/atom/atom/releases/download/${ATOM_VERSION}/atom-amd64.deb > /tmp/atom.deb && \
    dpkg -i /tmp/atom.deb && \
    rm -f /tmp/atom.deb && \
    useradd -d /home/atom -m atom

USER atom
# Atom Package Manager haskell plugins
RUN apm install language-haskell && \
	apm install ide-haskell-cabal && \
	apm install haskell-ghc-mod && \
	apm install autocomplete-haskell

RUN stack setup

RUN stack install stylish-haskell && \
	stack install ghc-mod && \
	stack install hlint

RUN echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc

VOLUME /app
WORKDIR /app

CMD ["/bin/bash"]